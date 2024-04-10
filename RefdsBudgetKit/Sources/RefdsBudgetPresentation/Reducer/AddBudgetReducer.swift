import Foundation
import RefdsRedux

public final class AddBudgetReducer: RefdsReduxReducerProtocol {
    public typealias State = BudgetStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? AddBudgetAction {
        case let .updateCategories(categories):
            state.categories = categories
            state.category = categories.first
        case let .updateBudget(id, amount, description):
            state.id = id
            state.amount = amount
            state.description = description
        case let .updateError(error):
            state.error = error
        case .dismiss,
                .save,
                .fetchCategories,
                .fetchBudget,
            nil:
            break
        }
        
        return state
    }
}
