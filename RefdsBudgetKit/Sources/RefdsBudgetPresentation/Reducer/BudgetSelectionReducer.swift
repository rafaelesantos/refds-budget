import Foundation
import RefdsRedux

public final class BudgetSelectionReducer: RefdsReduxReducerProtocol {
    public typealias State = BudgetSelectionStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? BudgetSelectionAction {
        case .fetchData:
            state.budgetsSelected = []
        case let .updateCategories(budgets):
            state.budgets = budgets
        case .none:
            break
        }
        
        return state
    }
}
