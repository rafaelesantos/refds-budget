import Foundation
import RefdsRedux

public final class BudgetComparisonReducer: RefdsReduxReducerProtocol {
    public typealias State = BudgetComparisonStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? BudgetComparisonAction {
        case .fetchData:
            state.isLoading = true
        case let .updateData(
            baseBudget,
            compareBudget,
            categoriesChart,
            tagsChart
        ):
            state.baseBudget = baseBudget
            state.compareBudget = compareBudget
            state.categoriesChart = categoriesChart
            state.tagsChart = tagsChart
            state.isLoading = false
        case .none:
            break
        }
        
        return state
    }
}
