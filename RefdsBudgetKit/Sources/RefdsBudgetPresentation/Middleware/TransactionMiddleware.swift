import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class TransactionMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { _, action, completion in
        switch action {
        case let action as AddTransactionAction:
            self.handler(for: action, on: completion)
        default:
            break
        }
    }
    
    private func handler(
        for addBudgetAction: AddTransactionAction,
        on completion: (AddTransactionAction) -> Void
    ) {
        switch addBudgetAction {
        case let .fetchRemaining(category, date):
            let amount = transactionRepository.getTransactions(
                on: category.id,
                from: date,
                format: .monthYear
            ).map { $0.amount }.reduce(.zero, +)
            let budgetAmount = categoryRepository.getBudget(on: category.id, from: date)?.amount ?? .zero
            let remaining = budgetAmount - amount
            completion(.updateRemaining(remaining))
            
        case let .save(transaction):
            guard let category = transaction.category else {
                return completion(.updateError(.notFoundCategory))
            }
            
            do {
                try transactionRepository.addTransaction(
                    id: transaction.id,
                    date: transaction.date,
                    message: transaction.description,
                    category: category.id,
                    amount: transaction.amount
                )
            } catch {
                return completion(.updateError(.existingTransaction))
            }
            
            completion(.dismiss)
            
        default:
            break
        }
    }
}
