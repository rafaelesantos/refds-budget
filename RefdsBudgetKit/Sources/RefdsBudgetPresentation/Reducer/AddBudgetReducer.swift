import Foundation
import RefdsRedux

public final class AddBudgetReducer: RefdsReduxReducerProtocol {
    public typealias State = BudgetStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? AddBudgetAction {
        case let .updateError(error):
            state.error = error
        case .dismiss, .save, nil:
            break
        }
        
        return state
    }
}
