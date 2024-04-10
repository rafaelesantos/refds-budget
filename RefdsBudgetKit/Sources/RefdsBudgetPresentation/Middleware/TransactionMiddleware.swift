import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class TransactionMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var repository: TransactionUseCase
    
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
            let amount = repository.getTransactions(
                on: category.id,
                from: date,
                format: .monthYear
            ).map { $0.amount }.reduce(.zero, +)
            
            let remaining = (category.budgets.first(where: {
                $0.month.asString(withDateFormat: .monthYear) == date.asString(withDateFormat: .monthYear)
            })?.amount ?? .zero) - amount
            
            completion(.updateRemaining(remaining))
            
        case let .save(transaction):
            guard let category = transaction.category else {
                return completion(.updateError(.notFoundCategory))
            }
            
            do {
                try repository.addTransaction(
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
