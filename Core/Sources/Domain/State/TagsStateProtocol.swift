import Foundation
import RefdsRedux

public protocol TagsStateProtocol: RefdsReduxState {
    var isLoading: Bool { get set }
    var selectedTag: TagItemViewDataProtocol { get set }
    var tags: [TagItemViewDataProtocol] { get set }
    var error: RefdsBudgetError? { get set }
    var canSave: Bool { get }
}
