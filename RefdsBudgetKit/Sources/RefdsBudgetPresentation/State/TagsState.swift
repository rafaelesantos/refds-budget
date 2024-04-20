import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsBudgetData

public protocol TagsStateProtocol: RefdsReduxState {
    var selectedTag: TagRowViewDataProtocol { get set }
    var tags: [TagRowViewDataProtocol] { get set }
    var isFilterEnable: Bool { get set }
    var date: Date { get set }
    var error: RefdsBudgetError? { get set }
    var canSave: Bool { get }
}

public struct TagsState: TagsStateProtocol {
    public var selectedTag: TagRowViewDataProtocol
    public var tags: [TagRowViewDataProtocol]
    public var isFilterEnable: Bool
    public var date: Date
    public var error: RefdsBudgetError?
    
    public var canSave: Bool {
        selectedTag.name.count > 2 &&
        !selectedTag.name.isEmpty
    }
    
    public init(
        selectedTag: TagRowViewDataProtocol = TagRowViewData(),
        tags: [TagRowViewDataProtocol] = [],
        isFilterEnable: Bool = true,
        date: Date = .current
    ) {
        self.selectedTag = selectedTag
        self.tags = tags
        self.isFilterEnable = isFilterEnable
        self.date = date
    }
}
