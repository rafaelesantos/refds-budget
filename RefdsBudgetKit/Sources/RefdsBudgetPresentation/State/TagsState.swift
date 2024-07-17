import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsBudgetData

public protocol TagsStateProtocol: RefdsReduxState {
    var selectedTag: TagRowViewDataProtocol { get set }
    var tags: [TagRowViewDataProtocol] { get set }
    var error: RefdsBudgetError? { get set }
    var isLoading: Bool { get set }
    var canSave: Bool { get }
}

public struct TagsState: TagsStateProtocol {
    public var selectedTag: TagRowViewDataProtocol
    public var tags: [TagRowViewDataProtocol]
    public var isLoading: Bool = true
    public var error: RefdsBudgetError?
    
    public var canSave: Bool {
        selectedTag.name.count > 2 &&
        !selectedTag.name.isEmpty
    }
    
    public init(
        selectedTag: TagRowViewDataProtocol = TagRowViewData(),
        tags: [TagRowViewDataProtocol] = []
    ) {
        self.selectedTag = selectedTag
        self.tags = tags
    }
}
