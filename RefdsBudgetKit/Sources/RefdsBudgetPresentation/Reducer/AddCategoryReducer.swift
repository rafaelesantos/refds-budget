import Foundation
import RefdsRedux

public final class AddCategoryReducer: RefdsReduxReducerProtocol {
    public typealias State = AddCategoryStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? AddCategoryAction {
        case let .updateCategroy(category):
            state = category
        case let .updateError(error):
            state.error = error
        case .dismiss, .save, nil:
            break
        }
        
        return state
    }
}
