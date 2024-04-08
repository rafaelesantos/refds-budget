import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class TransactionMiddleware: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var repository: TransactionUseCase
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<any RefdsReduxState> = { _, action, completion in
        switch action {
        case is AddTransactionAction:
            self.handler(for: action as? AddTransactionAction, on: completion)
        default:
            break
        }
        
    }
    
    private func handler(
        for addBudgetAction: AddTransactionAction?,
        on completion: RefdsReduxMiddlewareCompletion
    ) {
        switch addBudgetAction {
        case let .fetchRemaining(category, date):
            let amount = repository.getTransactions(
                on: category.id,
                from: date,
                format: .monthYear
            ).map { $0.amount }.reduce(0, +)
            
            let remaining = (category.budgets.first(where: {
                $0.month.asString(withDateFormat: .monthYear) == date.asString(withDateFormat: .monthYear)
            })?.amount ?? 0) - amount
            
            completion(AddTransactionAction.updateRemaining(remaining))
            
        case let .save(transaction):
            guard let category = transaction.category else {
                return completion(AddTransactionAction.updateError(.notFoundCategory))
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
                return completion(AddTransactionAction.updateError(.existingTransaction))
            }
            
            completion(AddTransactionAction.dismiss)
            
        default:
            break
        }
    }
}
