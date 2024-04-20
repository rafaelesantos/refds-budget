import Foundation
import RefdsRedux

public final class CategoriesReducer: RefdsReduxReducerProtocol {
    public typealias State = CategoriesStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? CategoriesAction {
        case .fetchData:
            state.isLoading = true
            
        case let .updateError(error):
            state.isLoading = false
            state.error = error
            
        case let .updateCategories(categories, isEmptyCategories, tags):
            state.isLoading = false
            state.categories = categories
            state.isEmptyCategories = isEmptyCategories
            state.tags = tags
            
        case let .updateBalance(balance):
            state.isLoading = false
            state.balance = balance
            
        case .removeBudget,
                .removeCategory,
                .fetchCategoryForEdit,
                .fetchBudgetForEdit,
                .showCategory,
                .addCategory,
                .addBudget, nil:
            break
        }
        
        return state
    }
}
