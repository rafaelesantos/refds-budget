import Foundation
import RefdsRedux
import RefdsBudgetData

public enum AddBudgetAction: RefdsReduxAction {
    case updateAmount(Double)
    case updateDescription(String)
    case updateDate(Date)
    case updateError(RefdsBudgetError)
    case dismiss
    case save
}
