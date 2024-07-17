import Foundation
import RefdsRedux

public final class TagReducer: RefdsReduxReducerProtocol {
    public typealias State = TagsStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? TagAction {
        case .fetchData:
            state.isLoading = true
        case let .updateData(tags):
            state.tags = tags
            state.selectedTag = TagRowViewData()
            state.isLoading = false
        case let .updateError(error):
            state.error = error
        case nil,
                .save,
                .removeTag:
            break
        }
        
        return state
    }
}
