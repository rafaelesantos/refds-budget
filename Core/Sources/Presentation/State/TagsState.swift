import Foundation
import Domain

struct TagsState: TagsStateProtocol {
    var isLoading: Bool
    var selectedTag: TagItemViewDataProtocol
    var tags: [TagItemViewDataProtocol]
    
    var error: RefdsBudgetError?
    
    var canSave: Bool {
        selectedTag.name.count > 2 &&
        !selectedTag.name.isEmpty
    }
    
    init(
        isLoading: Bool = true,
        selectedTag: TagItemViewDataProtocol = TagItemViewData(),
        tags: [TagItemViewDataProtocol] = []
    ) {
        self.isLoading = isLoading
        self.selectedTag = selectedTag
        self.tags = tags
    }
}
