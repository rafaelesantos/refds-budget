import Foundation
import RefdsRedux
import RefdsBudgetData

public enum ImportAction: RefdsReduxAction {
    case dismiss
    case save
    case updateError(RefdsBudgetError)
}
