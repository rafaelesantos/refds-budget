import Foundation
import RefdsRedux

public final class ApplicationReducer: RefdsReduxReducerProtocol {
    public typealias State = ApplicationStateProtocol
    
    public init() {}
    
    public lazy var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        state.addBudgetState = AddBudgetReducer().reduce(state.addBudgetState, action)
        state.addCategoryState = AddCategoryReducer().reduce(state.addCategoryState, action)
        state.categoriesState = CategoriesReducer().reduce(state.categoriesState, action)
        
        switch action {
        case let action as CategoriesAction:
            state = self.handler(with: state, for: action)
        default: break
        }
        
        return state
    }
    
    private func handler(
        with state: State,
        for action: CategoriesAction
    ) -> State {
        var state: State = state
        switch action {
        case .showCategoryDetail:
            break
        case let .addCategory(category):
            state.addCategoryState = category ?? AddCategoryState()
        case let .addBudget(budget, date):
            state.addBudgetState = budget ?? AddBudgetState(month: date ?? .current)
        default:
            break
        }
        return state
    }
}
