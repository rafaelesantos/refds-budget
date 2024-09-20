import Foundation
import RefdsRedux
import Domain

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
        case let .updateCategories(categories, categoriesWithoutBudget, isEmptyCategories):
            state.categories = categories
            state.categoriesWithoutBudget = categoriesWithoutBudget
            state.isEmptyCategories = isEmptyCategories
            state.isLoading = false
        case let .updateBalance(balance):
            state.balance = balance
        default: break
        }
        
        return state
    }
}
