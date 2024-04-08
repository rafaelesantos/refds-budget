import Foundation
import RefdsRedux
import RefdsBudgetData

public enum AddTransactionAction: RefdsReduxAction {
    case updateCategories([CategoryStateProtocol])
    case updateRemaining(Double)
    case updateError(RefdsBudgetError)
    case fetchRemaining(CategoryStateProtocol, Date)
    case fetchCategories(Date)
    case save(TransactionStateProtocol)
    case dismiss
}
