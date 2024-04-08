import Foundation
import RefdsRedux

public final class AddTransactionReducer: RefdsReduxReducerProtocol {
    public typealias State = TransactionStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? AddTransactionAction {
        case let .updateCategories(categories):
            state.categories = categories
        case let .updateRemaining(remaining):
            state.remaining = remaining
        case let .updateError(error):
            state.error = error
        case .dismiss, .save, .fetchRemaining, .fetchCategories, nil:
            break
        }
        
        return state
    }
}
