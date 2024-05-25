import Foundation
import RefdsRedux

public final class ImportReducer: RefdsReduxReducerProtocol {
    public typealias State = ImportStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? ImportAction {
        case .save:
            state.isLoading = true
        case .dismiss:
            state.isLoading = false
        case let .updateError(error):
            state.isLoading = false
            state.error = error
        default:
            break
        }
        
        return state
    }
}
