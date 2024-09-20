import Foundation
import Domain

public struct TagsStateMock: TagsStateProtocol {
    public var selectedTag: TagItemViewDataProtocol = TagItemViewDataMock()
    public var tags: [TagItemViewDataProtocol] = (1 ... 5).map { _ in TagItemViewDataMock() }
    public var isLoading: Bool = true
    public var error: RefdsBudgetError? = Bool.random() ? nil : .notFoundTag
    
    public var canSave: Bool { 
        selectedTag.name.count > 2 &&
        !selectedTag.name.isEmpty
    }
    
    public init() {}
}
