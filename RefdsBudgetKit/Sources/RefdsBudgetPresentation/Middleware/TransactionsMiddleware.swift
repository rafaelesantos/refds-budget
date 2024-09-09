import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource
import WidgetKit

public final class TransactionsMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var tagRepository: TagUseCase
    @RefdsInjection private var budgetRepository: BudgetUseCase
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    @RefdsInjection private var categoryAdapter: CategoryAdapterProtocol
    @RefdsInjection private var transactionRowViewDataAdapter: TransactionRowViewDataAdapterProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        switch action {
        case let action as TransactionsAction: self.handler(with: state.transactionsState, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: TransactionsStateProtocol,
        for action: TransactionsAction,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        switch action {
        case .fetchData:
            let date = state.filter.isDateFilter ? state.filter.date : nil
            fetchData(
                with: state.filter.searchText,
                and: state.filter.selectedItems,
                page: state.filter.currentPage,
                amountPage: state.filter.amountPage,
                from: date,
                on: completion
            )
        case let .fetchTransactionForEdit(transactionId): fetchTransactionForEdit(with: transactionId, on: completion)
        case let .removeTransaction(id): removeTransaction(with: state, by: id, on: completion)
        case let .removeTransactions(ids): removeTransactions(with: state, by: ids, on: completion)
        case let .updateStatus(id): updateStatus(for: id, on: completion)
        case let .shareText(ids):
            let date = state.filter.isDateFilter ? state.filter.date : nil
            shareText(
                for: ids,
                with: state.filter.searchText,
                and: state.filter.selectedItems,
                from: date,
                on: completion
            )
        case let .share(ids):
            let date = state.filter.isDateFilter ? state.filter.date : nil
            share(
                for: ids,
                with: state.filter.searchText,
                and: state.filter.selectedItems,
                from: date,
                on: completion
            )
        default: break
        }
    }
    
    private func fetchData(
        with searchText: String,
        and selectedItems: Set<String>,
        page: Int,
        amountPage: Int,
        from date: Date?,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        let transactionsAdapted = getTransactionsAdapted(
            with: searchText,
            and: selectedItems,
            from: date
        )
        
        let groupedTransactions = Dictionary(
            grouping: transactionsAdapted,
            by: { $0.date.asString(withDateFormat: .dayMonthYear) }
        ).map({ $0.value }).sorted(by: {
            ($0.first?.date ?? Date()) >=
            ($1.first?.date ?? Date())
        })
        
        if let range: ClosedRange<Int> = .range(
            page: page,
            amount: amountPage,
            count: groupedTransactions.indices.count
        ) {
            let filteredTransactions = Array(groupedTransactions[range])
            let canChangePage = page * filteredTransactions.count < groupedTransactions.count
            completion(.updateData(
                transactions: filteredTransactions,
                page: page,
                canChangePage: canChangePage
            ))
        } else {
            completion(.updateData(
                transactions: [],
                page: page,
                canChangePage: false
            ))
        }
    }
    
    private func getTransactionsAdapted(
        with searchText: String,
        and selectedItems: Set<String>,
        from date: Date?
    ) -> [TransactionRowViewDataProtocol] {
        var transactions: [TransactionModelProtocol] = []
        
        if let date = date {
            transactions = transactionRepository.getTransactions(from: date, format: .monthYear)
        } else {
            transactions = transactionRepository.getAllTransactions()
        }
        
        if !selectedItems.isEmpty {
            let status = TransactionStatus.allCases.filter { selectedItems.contains($0.description) }.map { $0.rawValue }
            if !status.isEmpty {
                transactions = transactions.filter { status.contains($0.status) }
            }
            
            let categoriesId = categoryRepository.getAllCategories().filter { selectedItems.contains($0.name) }.map { $0.id }
            if !categoriesId.isEmpty {
                transactions = transactions.filter { categoriesId.contains($0.category) }
            }
            
            let tags = tagRepository.getTags().filter { selectedItems.contains($0.name) }
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
        
        if !searchText.isEmpty {
            transactions = transactions.filter {
                $0.amount.asString.lowercased().contains(searchText.lowercased()) ||
                $0.message.lowercased().contains(searchText.lowercased())
            }
        }
        
        let transactionsAdapted: [TransactionRowViewDataProtocol] = transactions.compactMap {
            guard let category = categoryRepository.getCategory(by: $0.category) else { return nil }
            return transactionRowViewDataAdapter.adapt(
                model: $0,
                categoryModel: category
            )
        }
        
        return transactionsAdapted
    }
    
    private func fetchTransactionForEdit(
        with id: UUID,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        guard let transaction = transactionRepository.getTransaction(by: id) else {
            return completion(.updateError(.notFoundTransaction))
        }
        
        let categories: [CategoryRowViewDataProtocol] = categoryRepository.getCategories(from: transaction.date.date).compactMap {
            guard let budget = budgetRepository.getBudget(on: $0.id, from: transaction.date.date) else { return nil }
            let transactions = transactionRepository.getTransactions(on: $0.id, from: transaction.date.date, format: .dayMonthYear).map { $0.amount }
            let spend = transactions.reduce(.zero, +)
            let percentage = spend / (budget.amount == .zero ? 1 : budget.amount)
            return categoryAdapter.adapt(
                model: $0,
                budgetDescription: budget.message,
                budget: budget.amount,
                percentage: percentage,
                transactionsAmount: 1,
                spend: spend
            )
        }
        
        guard let category = categories.first(where: { $0.id == transaction.category }) else {
            return completion(.updateError(.notFoundCategory))
        }
        
        let viewData = AddTransactionState(
            id: transaction.id,
            amount: transaction.amount,
            description: transaction.message,
            status: TransactionStatus(rawValue: transaction.status) ?? .spend,
            category: category,
            categories: categories,
            remaining: nil,
            date: transaction.date.date,
            error: nil
        )
        
        completion(.addTransaction(viewData))
    }
    
    private func removeTransaction(
        with state: TransactionsStateProtocol,
        by id: UUID,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        do {
            try transactionRepository.removeTransaction(by: id)
        } catch { completion(.updateError(.notFoundTransaction)) }
        WidgetCenter.shared.reloadAllTimelines()
        completion(.fetchData)
    }
    
    private func removeTransactions(
        with state: TransactionsStateProtocol,
        by ids: Set<UUID>,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        do {
            try transactionRepository.removeTransactions(by: Array(ids))
            WidgetCenter.shared.reloadAllTimelines()
            completion(.fetchData)
        } catch {
            completion(.updateError(.notFoundTransaction))
        }
    }
    
    private func updateStatus(
        for id: UUID,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        guard let transaction = transactionRepository.getTransaction(by: id) else {
            return completion(.updateError(.notFoundTransaction))
        }
        var status = TransactionStatus(rawValue: transaction.status) ?? .spend
        status = status == .pending ? .cleared : status == .cleared ? .pending : .spend
        
        do {
            try transactionRepository.addTransaction(
                id: transaction.id,
                date: transaction.date.date,
                message: transaction.message,
                category: transaction.category,
                amount: transaction.amount,
                status: status
            )
            WidgetCenter.shared.reloadAllTimelines()
            completion(.fetchData)
        } catch {
            completion(.updateError(.cantSaveOnDatabase))
        }
    }
    
    private func shareText(
        for ids: Set<UUID>,
        with searchText: String,
        and selectedItems: Set<String>,
        from date: Date?,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        let ids = ids.isEmpty ? Set(getTransactionsAdapted(
            with: searchText,
            and: selectedItems,
            from: date
        ).map { $0.id }) : ids
        let text = FileFactory.shared.getTransactionsText(for: ids)
        completion(.updateShareText(text))
    }
    
    private func share(
        for ids: Set<UUID>,
        with searchText: String,
        and selectedItems: Set<String>,
        from date: Date?,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        let ids = ids.isEmpty ? Set(getTransactionsAdapted(
            with: searchText,
            and: selectedItems,
            from: date
        ).map { $0.id }) : ids
        let url = FileFactory.shared.getFileURL(transactionsId: ids)
        completion(.updateShare(url))
    }
}
