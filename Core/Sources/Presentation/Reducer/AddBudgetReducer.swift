import Foundation
import RefdsRedux
import Domain

public final class AddBudgetReducer: RefdsReduxReducerProtocol {
    public typealias State = AddBudgetStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? AddBudgetAction {
        case .fetchData, .fetchBudget:
            state.isLoading = true
        case let .updateData(id, description, date, amount, category, categories):
            state.id = id
            state.description = description
            state.date = date
            state.amount = amount
            state.category = category
            state.categories = categories
            state.isLoading = false
        case let .updateBudget(id, description, amount):
            state.id = id
            state.description = description
            state.amount = amount
            state.isLoading = false
        case let .updateError(error):
            state.error = error
            state.isLoading = false
        case .save, .none:
            break
        }
        
        return state
    }
}
