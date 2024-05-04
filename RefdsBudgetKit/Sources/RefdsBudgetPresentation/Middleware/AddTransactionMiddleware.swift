import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource
import WidgetKit

public final class AddTransactionMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    @RefdsInjection private var categoryAdapter: CategoryAdapterProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { _, action, completion in
        switch action {
        case let action as AddTransactionAction: self.handler(for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        for addBudgetAction: AddTransactionAction,
        on completion: @escaping (AddTransactionAction) -> Void
    ) {
        switch addBudgetAction {
        case let .fetchCategories(date): self.fetchCategories(from: date, on: completion)
        case let .save(transaction): self.save(transaction: transaction, on: completion)
        default: break
        }
    }
    
    private func fetchCategories(
        from date: Date,
        on completion: @escaping (AddTransactionAction) -> Void
    ) {
        let allCategories = categoryRepository.getAllCategories()
        let categories: [CategoryRowViewDataProtocol] = categoryRepository.getCategories(from: date).compactMap {
            guard let budget = categoryRepository.getBudget(on: $0.id, from: date) else { return nil }
            let transactions = transactionRepository.getTransactions(on: $0.id, from: date, format: .monthYear)
            let spend = transactions.map { $0.amount }.reduce(.zero, +)
            let percentage = spend / (budget.amount == .zero ? 1 : budget.amount)
            return categoryAdapter.adapt(
                entity: $0,
                budgetId: budget.id,
                budgetDescription: budget.message,
                budget: budget.amount,
                percentage: percentage,
                transactionsAmount: transactions.count,
                spend: spend
            )
        }
        completion(.updateCategories(categories, allCategories.isEmpty))
    }
    
    private func save(
        transaction: AddTransactionStateProtocol,
        on completion: @escaping (AddTransactionAction) -> Void
    ) {
        guard let category = transaction.category else {
            return completion(.updateError(.notFoundCategory))
        }
        
        do {
            try transactionRepository.addTransaction(
                id: transaction.id,
                date: transaction.date,
                message: transaction.description,
                category: category.categoryId,
                amount: transaction.amount
            )
        } catch {
            return completion(.updateError(.existingTransaction))
        }
        WidgetCenter.shared.reloadAllTimelines()
        completion(.dismiss)
    }
}
