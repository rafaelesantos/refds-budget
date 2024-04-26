import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class HomeMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var tagRepository: BubbleUseCase
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    @RefdsInjection private var categoryAdapter: CategoryAdapterProtocol
    @RefdsInjection private var transactionRowViewDataAdapter: TransactionRowViewDataAdapterProtocol
    @RefdsInjection private var tagRowViewDataAdapter: TagRowViewDataAdapterProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        switch action {
        case let action as HomeAction: self.handler(with: state.homeState, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: HomeStateProtocol,
        for action: HomeAction,
        on completion: @escaping (HomeAction) -> Void
    ) {
        switch action {
        case let .fetchData(date): fetchData(from: date, state: state, on: completion)
        default: break
        }
    }
    
    private func fetchData(
        from date: Date?,
        state: HomeStateProtocol,
        on completion: @escaping (HomeAction) -> Void
    ) {
        var budgetEntities: [BudgetEntity] = []
        var categoryEntities: [CategoryEntity] = []
        var transactionEntities: [TransactionEntity] = []
        let tagEntities = tagRepository.getBubbles()
        
        if let date = date {
            transactionEntities = transactionRepository.getTransactions(from: date, format: .monthYear)
            categoryEntities = categoryRepository.getCategories(from: date)
            budgetEntities = categoryRepository.getBudgets(from: date)
        } else {
            transactionEntities = transactionRepository.getTransactions()
            categoryEntities = categoryRepository.getAllCategories()
            budgetEntities = categoryRepository.getAllBudgets()
        }
        
        if !state.selectedCategories.isEmpty {
            let categoriesId = categoryRepository.getAllCategories().filter { state.selectedCategories.contains($0.name) }.map { $0.id }
            transactionEntities = transactionEntities.filter { categoriesId.contains($0.category) }
        }
        
        if !state.selectedTags.isEmpty {
            transactionEntities = transactionEntities.filter { transaction in
                for tagName in state.selectedTags {
                    if transaction.message
                        .folding(options: .diacriticInsensitive, locale: .current)
                        .lowercased()
                        .contains(
                            tagName
                                .folding(options: .diacriticInsensitive, locale: .current)
                                .lowercased()
                        ) {
                        return true
                    }
                }
                return false
            }
        }
        
        let remaining = getRemaining(
            for: categoryEntities,
            on: transactionEntities,
            with: budgetEntities
        )
        
        let tags = getTagsRow(
            for: transactionEntities,
            with: tagEntities
        )
        
        let largestPurchase = getLargestPurchase(
            on: transactionEntities,
            with: categoryEntities
        )
        
        completion(
            .updateData(
                remaining: remaining,
                tags: tags,
                largestPurchase: largestPurchase,
                tagsMenu: tagEntities.map { $0.name },
                categoriesMenu: categoryEntities.map { $0.name }
            )
        )
    }
    
    private func getRemaining(
        for categoryEntities: [CategoryEntity],
        on transactionEntities: [TransactionEntity],
        with budgetEntities: [BudgetEntity]
    ) -> [CategoryRowViewDataProtocol] {
        categoryEntities.compactMap { entity in
            let budgetEntities = budgetEntities.filter { $0.category == entity.id }
            let transactionEntities = transactionEntities.filter { $0.category == entity.id }
            
            guard let budget = budgetEntities.last else { return nil }
            let budgetAmount = budgetEntities.map { $0.amount }.reduce(.zero, +)
            let spend = transactionEntities.map { $0.amount }.reduce(.zero, +)
            let percentage = spend / (budgetAmount == .zero ? 1 : budgetAmount)
            
            return categoryAdapter.adapt(
                entity: entity,
                budgetId: budget.id,
                budgetDescription: budget.message,
                budget: budgetAmount,
                percentage: percentage,
                transactionsAmount: transactionEntities.count,
                spend: spend
            )
        }
    }
    
    private func getTagsRow(
        for transactionEntities: [TransactionEntity],
        with tagEntities: [BubbleEntity]
    ) -> [TagRowViewDataProtocol] {
        tagEntities.compactMap { tag in
            guard let tagName = tag.name.applyingTransform(.stripDiacritics, reverse: false) else { return nil }
            let value = transactionEntities.filter {
                $0.message
                    .applyingTransform(.stripDiacritics, reverse: false)?
                    .lowercased()
                    .contains(tagName.lowercased()) ?? false
            }.map { $0.amount }
            return tagRowViewDataAdapter.adapt(
                entity: tag,
                value: value.reduce(.zero, +),
                amount: value.count
            )
        }
    }
    
    private func getLargestPurchase(
        on transactionEntities: [TransactionEntity],
        with categoryEntities: [CategoryEntity]
    ) -> [TransactionRowViewDataProtocol] {
        let transactionEntities = transactionEntities.sorted(by: { $0.amount > $1.amount }).prefix(5)
        return transactionEntities.compactMap { entity in
            guard let category = categoryEntities.first(where: { $0.id == entity.category }) else { return nil }
            return transactionRowViewDataAdapter.adapt(
                transactionEntity: entity,
                categoryEntity: category
            )
        }
    }
}
