import Foundation
import RefdsRedux
import RefdsBudgetData

public enum TagAction: RefdsReduxAction {
    case fetchData
    case updateData(tags: [TagRowViewDataProtocol])
    case updateError(RefdsBudgetError)
    case removeTag(UUID)
    case save
}
