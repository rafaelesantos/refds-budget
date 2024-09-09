import Foundation
import RefdsRedux
import RefdsBudgetDomain

public enum ImportAction: RefdsReduxAction {
    case dismiss
    case save
    case updateError(RefdsBudgetError)
}
