import Foundation
import RefdsRedux

public final class AddBudgetReducer: RefdsReduxReducerProtocol {
    public typealias State = AddBudgetStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? AddBudgetAction {
        case let .updateCategories(categories, budgetId, budgetAmount, budgetDescription):
            state.categories = categories
            state.category = categories.first
            state.id = budgetId
            state.amount = budgetAmount
            state.description = budgetDescription
        case let .updateBudget(id, amount, description):
            state.id = id
            state.amount = amount
            state.description = description
        case let .updateError(error):
            state.error = error
        default:
            break
        }
        
        return state
    }
}
