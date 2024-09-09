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
        case let .updateCategories(categories, isEmptyCategories):
            state.categories = categories
            state.isEmptyCategories = isEmptyCategories
            state.isLoading = false
        case let .updateBalance(balance):
            state.balance = balance
        default: break
        }
        
        return state
    }
}
