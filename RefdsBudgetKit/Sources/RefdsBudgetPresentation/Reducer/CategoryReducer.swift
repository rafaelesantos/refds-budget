import Foundation
import RefdsRedux

public final class CategoryReducer: RefdsReduxReducerProtocol {
    public typealias State = CategoryStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? CategoryAction {
        case .fetchData:
            state.isLoading = true
        case let .updateData(description, category, budgets, canChangePage):
            state.description = description
            state.category = category
            state.budgets = budgets
            state.filter.canChangePage = canChangePage
            state.isLoading = false
        case let .updateError(error):
            state.error = error
        case .removeBudget, .removeCategory, .none:
            break
        }
        
        return state
    }
}
