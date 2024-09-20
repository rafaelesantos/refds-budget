import Foundation
import RefdsRedux

public enum TagAction: RefdsReduxAction {
    case fetchData
    case updateData(tags: [TagItemViewDataProtocol])
    case updateError(RefdsBudgetError)
    case removeTag(UUID)
    case save
}
