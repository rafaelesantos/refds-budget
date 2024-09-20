import Foundation
import RefdsRedux
import Domain

public final class SettingsReducer: RefdsReduxReducerProtocol {
    public typealias State = SettingsStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? SettingsAction {
        case .fetchData, .share:
            state.isLoading = true
        case let .receiveData(newState):
            state = newState
        case let .updateError(error):
            state.error = error
        case let .updateShare(url):
            state.share = url
            state.isLoading = false
        default: break
        }
        
        return state
    }
}
