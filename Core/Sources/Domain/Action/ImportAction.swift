import Foundation
import RefdsRedux

public enum ImportAction: RefdsReduxAction {
    case dismiss
    case save
    case updateError(RefdsBudgetError)
}
