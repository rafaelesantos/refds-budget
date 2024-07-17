import Foundation
import RefdsRedux

public final class AddBudgetReducer: RefdsReduxReducerProtocol {
    public typealias State = AddBudgetStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? AddBudgetAction {
        case .fetchCategories:
            state.isLoading = true
        case let .updateCategories(categories, budgetId, budgetAmount, budgetDescription):
            state.categories = categories
            state.id = budgetId
            state.amount = budgetAmount
            state.description = budgetDescription
            state.isLoading = false
            if state.category == nil {
                state.category = categories.first
            }
            state.isAI = false
        case let .updateBudget(id, amount, description, isAI):
            state.id = id
            state.amount = amount
            state.description = description
            state.isLoading = false
            state.isAI = isAI
        case let .updateError(error):
            state.error = error
            state.isLoading = false
        default:
            break
        }
        
        return state
    }
}
