import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class HomeMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var tagRepository: TagUseCase
    @RefdsInjection private var budgetRepository: BudgetUseCase
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
        case .fetchData: fetchData(state: state, on: completion)
        default: break
        }
    }
    
    private func fetchData(
        state: HomeStateProtocol,
        on completion: @escaping (HomeAction) -> Void
    ) {
        var budgetEntities: [BudgetModelProtocol] = []
        var categoryEntities: [CategoryModelProtocol] = []
        var transactionEntities: [TransactionModelProtocol] = []
        let tagEntities = tagRepository.getTags()
        
        if state.isFilterEnable {
            let date = state.date
            transactionEntities = transactionRepository.getTransactions(from: date, format: .monthYear)
            categoryEntities = categoryRepository.getCategories(from: date)
            budgetEntities = budgetRepository.getBudgets(from: date)
        } else {
            transactionEntities = transactionRepository.getAllTransactions()
            categoryEntities = categoryRepository.getAllCategories()
            budgetEntities = budgetRepository.getAllBudgets()
        }
        
        if !state.selectedCategories.isEmpty {
            let categoriesId = categoryRepository.getAllCategories().filter { state.selectedCategories.contains($0.name) }.map { $0.id }
            transactionEntities = transactionEntities.filter { categoriesId.contains($0.category) }
        }
        
        if !state.selectedTags.isEmpty {
            transactionEntities = transactionEntities.filter { transaction in
                var contains = true
                for tagName in state.selectedTags {
                    if !transaction.message
                        .folding(options: .diacriticInsensitive, locale: .current)
                        .lowercased()
                        .contains(
                            tagName
                                .folding(options: .diacriticInsensitive, locale: .current)
                                .lowercased()
                        ) {
                        contains = false
                    }
                }
                return contains
            }
        }
        
        if !state.selectedStatus.isEmpty {
            transactionEntities = transactionEntities.filter {
                state.selectedStatus.contains(TransactionStatus(rawValue: $0.status)?.description ?? "")
            }
        }
        
        let remaining = getRemaining(
            for: categoryEntities,
            on: transactionEntities,
            with: budgetEntities,
            status: state.selectedStatus
        ).sorted(by: { $0.spend > $1.spend })
        
        let tags = getTagsRow(
            for: transactionEntities,
            with: tagEntities,
            status: state.selectedStatus
        )
        
        let largestPurchase = getLargestPurchase(
            on: transactionEntities,
            with: categoryEntities,
            status: state.selectedStatus
        )
        
        let pendingCleared = getPendingCleared(on: transactionEntities)
        
        completion(
            .updateData(
                remaining: remaining,
                tags: tags,
                largestPurchase: largestPurchase,
                pendingCleared: pendingCleared,
                tagsMenu: tagEntities.map { $0.name },
                categoriesMenu: categoryEntities.map { $0.name }
            )
        )
    }
    
    private func getRemaining(
        for categoryEntities: [CategoryModelProtocol],
        on transactionEntities: [TransactionModelProtocol],
        with budgetEntities: [BudgetModelProtocol],
        status: Set<String>
    ) -> [CategoryRowViewDataProtocol] {
        categoryEntities.compactMap { entity in
            let budgetEntities = budgetEntities.filter { $0.category == entity.id }
            let transactionEntities = transactionEntities.filter { $0.category == entity.id }.filter {
                if status.isEmpty {
                    return $0.status != TransactionStatus.pending.rawValue &&
                    $0.status != TransactionStatus.cleared.rawValue
                } else {
                    return true
                }
            }
            
            guard let budget = budgetEntities.last else { return nil }
            let budgetAmount = budgetEntities.map { $0.amount }.reduce(.zero, +)
            let spend = transactionEntities.map { $0.amount }.reduce(.zero, +)
            let percentage = spend / (budgetAmount == .zero ? 1 : budgetAmount)
            
            return categoryAdapter.adapt(
                model: entity,
                budgetId: budget.id,
                budgetDescription: budget.message,
                budget: budgetAmount,
                percentage: percentage,
                transactionsAmount: transactionEntities.count,
                spend: spend
            )
        }.filter { $0.transactionsAmount > 0 }
    }
    
    private func getTagsRow(
        for transactionEntities: [TransactionModelProtocol],
        with tagEntities: [TagModelProtocol],
        status: Set<String>
    ) -> [TagRowViewDataProtocol] {
        tagEntities.compactMap { tag in
            guard let tagName = tag.name.applyingTransform(.stripDiacritics, reverse: false) else { return nil }
            let value = transactionEntities.filter {
                $0.message
                    .applyingTransform(.stripDiacritics, reverse: false)?
                    .lowercased()
                    .contains(tagName.lowercased()) ?? false
            }.filter {
                if status.isEmpty {
                    return $0.status != TransactionStatus.pending.rawValue &&
                    $0.status != TransactionStatus.cleared.rawValue
                } else {
                    return true
                }
            }.map { $0.amount }
            return tagRowViewDataAdapter.adapt(
                model: tag,
                value: value.reduce(.zero, +),
                amount: value.count
            )
        }
    }
    
    private func getLargestPurchase(
        on transactionEntities: [TransactionModelProtocol],
        with categoryEntities: [CategoryModelProtocol],
        status: Set<String>
    ) -> [TransactionRowViewDataProtocol] {
        let transactionEntities = transactionEntities.filter {
            if status.isEmpty {
                return $0.status != TransactionStatus.pending.rawValue &&
                $0.status != TransactionStatus.cleared.rawValue
            } else {
                return true
            }
        }.sorted(by: { $0.amount > $1.amount }).prefix(5)
        return transactionEntities.compactMap { entity in
            guard let category = categoryEntities.first(where: { $0.id == entity.category }) else { return nil }
            return transactionRowViewDataAdapter.adapt(
                model: entity,
                categoryModel: category
            )
        }
    }
    
    private func getPendingCleared(
        on transactionEntities: [TransactionModelProtocol]
    ) -> PendingClearedSectionViewDataProtocol {
        let pendings = transactionEntities.filter {
            let status = TransactionStatus(rawValue: $0.status)
            return status == .pending
        }.map { $0.amount }
        
        let cleareds = transactionEntities.filter {
            let status = TransactionStatus(rawValue: $0.status)
            return status == .cleared
        }.map { $0.amount }
        
        return PendingClearedSectionViewData(
            pendingAmount: pendings.reduce(.zero, +),
            clearedAmount: cleareds.reduce(.zero, +),
            pendingCount: pendings.count,
            clearedCount: cleareds.count
        )
    }
}
