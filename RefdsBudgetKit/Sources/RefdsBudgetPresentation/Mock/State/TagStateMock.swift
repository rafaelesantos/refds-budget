import SwiftUI
import RefdsBudgetDomain

public struct TagsStateMock: TagsStateProtocol {
    public var selectedTag: TagRowViewDataProtocol = TagRowViewDataMock()
    public var tags: [TagRowViewDataProtocol] = (1 ... 5).map { _ in TagRowViewDataMock() }
    public var isLoading: Bool = true
    public var error: RefdsBudgetError? = Bool.random() ? nil : .notFoundTag
    
    public var canSave: Bool { 
        selectedTag.name.count > 2 &&
        !selectedTag.name.isEmpty
    }
    
    public init() {}
}
