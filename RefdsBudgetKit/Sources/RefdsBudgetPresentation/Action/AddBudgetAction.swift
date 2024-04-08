import Foundation
import RefdsRedux
import RefdsBudgetData

public enum AddBudgetAction: RefdsReduxAction {
    case updateError(RefdsBudgetError)
    case save(BudgetStateProtocol)
    case dismiss
}
