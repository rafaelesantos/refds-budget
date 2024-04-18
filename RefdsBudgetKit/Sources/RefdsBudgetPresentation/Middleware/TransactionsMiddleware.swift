import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class TransactionsMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    @RefdsInjection private var categoryAdapter: CategoryAdapterProtocol
    @RefdsInjection private var transactionRowViewDataAdapter: TransactionRowViewDataAdapterProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        switch action {
        case let action as TransactionsAction: self.handler(with: state.transactions, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: TransactionsStateProtocol,
        for action: TransactionsAction,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        switch action {
        case let .fetchData(date, searchText): fetchData(with: searchText, from: date, on: completion)
        case let .fetchTransactionForEdit(transactionId): fetchTransactionForEdit(with: transactionId, on: completion)
        case let .removeTransaction(id): removeTransaction(with: state, by: id, on: completion)
        case let .removeTransactions(ids): removeTransactions(with: state, by: ids, on: completion)
        case let .copyTransactions(ids): copyTransactions(by: ids, on: completion)
        default: break
        }
    }
    
    private func fetchData(
        with searchText: String,
        from date: Date?,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        var transactions: [TransactionEntity] = []
        
        if let date = date {
            transactions = transactionRepository.getTransactions(from: date, format: .monthYear)
        } else {
            transactions = transactionRepository.getTransactions()
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
                transactionEntity: $0,
                categoryEntity: category
            )
        }
        
        let groupedTransactions = Dictionary(
            grouping: transactionsAdapted,
            by: { $0.date.asString(withDateFormat: .dayMonthYear) }
        ).map({ $0.value }).sorted(by: {
            ($0.first?.date ?? Date()) >=
            ($1.first?.date ?? Date())
        })
        
        return completion(.updateData(transactions: groupedTransactions))
    }
    
    private func fetchTransactionForEdit(
        with id: UUID,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        guard let transaction = transactionRepository.getTransaction(by: id) else {
            return completion(.updateError(.notFoundTransaction))
        }
        
        let categories: [CategoryRowViewDataProtocol] = categoryRepository.getCategories(from: transaction.date.date).compactMap {
            guard let budget = categoryRepository.getBudget(on: $0.id, from: transaction.date.date) else { return nil }
            let transactions = transactionRepository.getTransactions(on: $0.id, from: transaction.date.date, format: .dayMonthYear).map { $0.amount }
            let spend = transactions.reduce(.zero, +)
            let percentage = spend / (budget.amount == .zero ? 1 : budget.amount)
            return categoryAdapter.adapt(
                entity: $0,
                budgetId: budget.id,
                budgetDescription: budget.message,
                budget: budget.amount,
                percentage: percentage,
                transactionsAmount: 1,
                spend: spend
            )
        }
        
        guard let category = categories.first(where: { $0.categoryId == transaction.category }) else {
            return completion(.updateError(.notFoundCategory))
        }
        
        let viewData = AddTransactionState(
            id: transaction.id,
            amount: transaction.amount,
            description: transaction.message,
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
        
        fetchData(with: state.searchText, from: state.isFilterEnable ? state.date : nil, on: completion)
    }
    
    private func removeTransactions(
        with state: TransactionsStateProtocol,
        by ids: Set<UUID>,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        ids.forEach { id in
            try? transactionRepository.removeTransaction(by: id)
        }
        fetchData(with: state.searchText, from: state.isFilterEnable ? state.date : nil, on: completion)
    }
    
    private func copyTransactions(
        by ids: Set<UUID>,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        var transactions = ""
        var total: Double = .zero
        var count: Int = .zero
        var startDate: TimeInterval = Date().timestamp
        var endDate: TimeInterval = .zero
    
        ids.forEach { id in
            if let transaction = transactionRepository.getTransaction(by: id) {
                let category = categoryRepository.getCategory(by: transaction.category)
                total += transaction.amount
                count += 1
                if transaction.date < startDate { startDate = transaction.date }
                if transaction.date > endDate { endDate = transaction.date }
                
                transactions += """
                • \(transaction.amount.currency()) - \(transaction.date.asString(withDateFormat: .dayMonthYear))
                \(category?.name ?? "") - \(transaction.message)\n\n
                """
            }
        }
        
        transactions = .localizable(by: .transactionsCopyHeader, with: count, startDate.asString(), endDate.asString()) + transactions
        transactions += .localizable(by: .transactionsCopyFooter, with: total.currency())
        
        #if os(macOS)
        NSPasteboard.general.setString(transactions, forType: .string)
        #else
        UIPasteboard.general.string = transactions
        #endif
    }
}
