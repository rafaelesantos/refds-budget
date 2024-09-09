import Foundation
import RefdsRedux
import RefdsBudgetDomain

public enum TagAction: RefdsReduxAction {
    case fetchData
    case updateData(tags: [TagRowViewDataProtocol])
    case updateError(RefdsBudgetError)
    case removeTag(UUID)
    case save
}
