import Foundation
import RefdsRedux

public final class AddBudgetReducer: RefdsReduxReducerProtocol {
    public typealias State = AddBudgetStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? AddBudgetAction {
        case let .updateAmount(amount):
            state.amount = amount
        case let .updateDescription(description):
            state.description = description
        case let .updateDate(date):
            state.month = date
        case let .updateError(error):
            state.error = error
        case .dismiss, .save, nil:
            break
        }
        
        return state
    }
}
