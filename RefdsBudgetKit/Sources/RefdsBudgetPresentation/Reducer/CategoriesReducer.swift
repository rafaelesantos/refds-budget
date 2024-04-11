import Foundation
import RefdsRedux

public final class CategoriesReducer: RefdsReduxReducerProtocol {
    public typealias State = CategoriesStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as! CategoriesAction {
        case .fetchCategories:
            state.isLoading = true
        case let .updateError(error):
            state.isLoading = false
            state.error = error
        case let .updateCategories(categories):
            state.isLoading = false
            state.categories = categories
        case let .updateCurrentValues(currentValues):
            state.isLoading = false
            state.currentValues = currentValues
        case .fetchCurrentValues,
                .showEditCategory,
                .showEditBudget,
                .showCategoryDetail,
                .addCategory,
                .addBudget:
            break
        }
        
        return state
    }
}
