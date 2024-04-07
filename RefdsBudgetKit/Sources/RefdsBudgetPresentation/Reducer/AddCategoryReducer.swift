import Foundation
import RefdsRedux

public final class AddCategoryReducer: RefdsReduxReducerProtocol {
    public typealias State = AddCategoryStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? AddCategoryAction {
        case let .updateName(name):
            state.name = name
        case let .updateColor(color):
            state.color = color
        case let .updateIcon(icon):
            state.icon = icon
        case let .updateBudgets(budgets):
            state.budgets = budgets
        case let .updateError(error):
            state.error = error
        case .dismiss, .save, nil:
            break
        }
        
        return state
    }
}
