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
        var categories: [CategoryModelProtocol] = []
        var transactions: [TransactionModelProtocol] = []
        let tags = tagRepository.getTags()
        
        if state.filter.isDateFilter {
            let date = state.filter.date
            transactions = transactionRepository.getTransactions(from: date, format: .monthYear)
            categories = categoryRepository.getCategories(from: date)
            budgetEntities = budgetRepository.getBudgets(from: date)
        } else {
            transactions = transactionRepository.getAllTransactions()
            categories = categoryRepository.getAllCategories()
            budgetEntities = budgetRepository.getAllBudgets()
        }
        
        if !state.filter.selectedItems.isEmpty {
            let status = TransactionStatus.allCases.filter { state.filter.selectedItems.contains($0.description) }.map { $0.rawValue }
            if !status.isEmpty {
                transactions = transactions.filter { status.contains($0.status) }
            }
            
            let categoriesId = categoryRepository.getAllCategories().filter { state.filter.selectedItems.contains($0.name) }.map { $0.id }
            if !categoriesId.isEmpty {
                transactions = transactions.filter { categoriesId.contains($0.category) }
            }
            
            let tags = tagRepository.getTags().filter { state.filter.selectedItems.contains($0.name) }
            if !tags.isEmpty {
                transactions = transactions.filter { transaction in
                    var contains = true
                    for tag in tags {
                        if !transaction.message
                            .folding(options: .diacriticInsensitive, locale: .current)
                            .lowercased()
                            .contains(
                                tag.name
                                    .folding(options: .diacriticInsensitive, locale: .current)
                                    .lowercased()
                            ) {
                            contains = false
                        }
                    }
                    return contains
                }
            }
        }
        
        if !state.filter.searchText.isEmpty {
            transactions = transactions.filter {
                $0.amount.asString.lowercased().contains(state.filter.searchText.lowercased()) ||
                $0.message.lowercased().contains(state.filter.searchText.lowercased())
            }
        }
        
        let pendingCleared = getPendingCleared(on: transactions)
        
        completion(
            .updateData(
                remaining: [],
                tags: [],
                largestPurchase: [],
                pendingCleared: pendingCleared
            )
        )
        
        let status = TransactionStatus.allCases.map { $0.description }
        let selectedStatus = state.filter.selectedItems.filter { status.contains($0) }
        
        let remaining = getRemaining(
            for: categories,
            on: transactions,
            with: budgetEntities,
            status: selectedStatus
        ).sorted(by: { $0.spend > $1.spend })
        
        completion(
            .updateData(
                remaining: remaining,
                tags: [],
                largestPurchase: [],
                pendingCleared: pendingCleared
            )
        )
        
        let tagRows = getTagsRow(
            for: transactions,
            with: tags,
            status: selectedStatus
        )
        
        completion(
            .updateData(
                remaining: remaining,
                tags: tagRows,
                largestPurchase: [],
                pendingCleared: pendingCleared
            )
        )
        
        let largestPurchase = getLargestPurchase(
            on: transactions,
            with: categories,
            status: selectedStatus
        )
        
        completion(
            .updateData(
                remaining: remaining,
                tags: tagRows,
                largestPurchase: largestPurchase,
                pendingCleared: pendingCleared
            )
        )
    }
    
    private func getRemaining(
        for categories: [CategoryModelProtocol],
        on transactions: [TransactionModelProtocol],
        with budgetEntities: [BudgetModelProtocol],
        status: Set<String>
    ) -> [CategoryRowViewDataProtocol] {
        categories.compactMap { entity in
            let budgetEntities = budgetEntities.filter { $0.category == entity.id }
            let transactions = transactions.filter { $0.category == entity.id }.filter {
                if status.isEmpty {
                    return $0.status != TransactionStatus.pending.rawValue &&
                    $0.status != TransactionStatus.cleared.rawValue
                } else {
                    return true
                }
            }
            
            guard let budget = budgetEntities.last else { return nil }
            let budgetAmount = budgetEntities.map { $0.amount }.reduce(.zero, +)
            let spend = transactions.map { $0.amount }.reduce(.zero, +)
            let percentage = spend / (budgetAmount == .zero ? 1 : budgetAmount)
            
            return categoryAdapter.adapt(
                model: entity,
                budgetDescription: budget.message,
                budget: budgetAmount,
                percentage: percentage,
                transactionsAmount: transactions.count,
                spend: spend
            )
        }.filter { $0.transactionsAmount > 0 }
    }
    
    private func getTagsRow(
        for transactions: [TransactionModelProtocol],
        with tags: [TagModelProtocol],
        status: Set<String>
    ) -> [TagRowViewDataProtocol] {
        tags.compactMap { tag in
            guard let tagName = tag.name.applyingTransform(.stripDiacritics, reverse: false) else { return nil }
            let value = transactions.filter {
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
        on transactions: [TransactionModelProtocol],
        with categories: [CategoryModelProtocol],
        status: Set<String>
    ) -> [TransactionRowViewDataProtocol] {
        let transactions = transactions.filter {
            if status.isEmpty {
                return $0.status != TransactionStatus.pending.rawValue &&
                $0.status != TransactionStatus.cleared.rawValue
            } else {
                return true
            }
        }.sorted(by: { $0.amount > $1.amount }).prefix(5)
        return transactions.compactMap { entity in
            guard let category = categories.first(where: { $0.id == entity.category }) else { return nil }
            return transactionRowViewDataAdapter.adapt(
                model: entity,
                categoryModel: category
            )
        }
    }
    
    private func getPendingCleared(
        on transactions: [TransactionModelProtocol]
    ) -> PendingClearedSectionViewDataProtocol {
        let pendings = transactions.filter {
            let status = TransactionStatus(rawValue: $0.status)
            return status == .pending
        }.map { $0.amount }
        
        let cleareds = transactions.filter {
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
