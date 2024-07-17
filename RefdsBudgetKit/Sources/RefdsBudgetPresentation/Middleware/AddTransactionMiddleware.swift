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
    @RefdsInjection private var categoryIntelligence: CategoryIntelligenceProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = (state as? ApplicationStateProtocol)?.addTransactionState else { return }
        switch action {
        case let action as AddTransactionAction: self.handler(with: state, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: AddTransactionStateProtocol,
        for addTransactionAction: AddTransactionAction,
        on completion: @escaping (AddTransactionAction) -> Void
    ) {
        switch addTransactionAction {
        case let .fetchCategories(date, amount): fetchCategories(
            from: date,
            amount: amount,
            on: completion
        )
        case let .save(amount, description): save(
            with: state,
            amount: amount,
            description: description,
            on: completion
        )
        default: break
        }
    }
    
    private func fetchCategories(
        from date: Date,
        amount: Double,
        on completion: @escaping (AddTransactionAction) -> Void
    ) {
        let allCategories = categoryRepository.getAllCategories()
        let categories: [CategoryRowViewDataProtocol] = categoryRepository.getCategories(from: date).compactMap {
            guard let budget = categoryRepository.getBudget(on: $0.id, from: date) else { return nil }
            let transactions = transactionRepository.getTransactions(on: $0.id, from: date, format: .monthYear).filter {
                let status = TransactionStatus(rawValue: $0.status)
                return status != .pending && status != .cleared
            }
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
        
        if let categoryId = categoryIntelligence.predict(date: date, amount: amount),
           let category = categories.first(where: { $0.categoryId == categoryId }),
           amount > .zero {
            completion(.updateCategories(category, categories, allCategories.isEmpty))
        } else {
            completion(.updateCategories(nil, categories, allCategories.isEmpty))
        }
    }
    
    private func save(
        with state: AddTransactionStateProtocol,
        amount: Double,
        description: String,
        on completion: @escaping (AddTransactionAction) -> Void
    ) {
        guard let category = state.category else {
            return completion(.updateError(.notFoundCategory))
        }
        
        do {
            try transactionRepository.addTransaction(
                id: state.id,
                date: state.date,
                message: description,
                category: category.categoryId,
                amount: amount,
                status: state.status
            )
            WidgetCenter.shared.reloadAllTimelines()
            completion(.dismiss)
        } catch {
            completion(.updateError(.existingTransaction))
        }
    }
}
