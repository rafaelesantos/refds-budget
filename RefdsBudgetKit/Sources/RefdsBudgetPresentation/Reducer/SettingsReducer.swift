import Foundation
import RefdsRedux

public final class SettingsReducer: RefdsReduxReducerProtocol {
    public typealias State = SettingsStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? SettingsAction {
        case .fetchData:
            state.isLoading = true
        case let .receiveData(newState):
            state = newState
        default: break
        }
        
        return state
    }
}
