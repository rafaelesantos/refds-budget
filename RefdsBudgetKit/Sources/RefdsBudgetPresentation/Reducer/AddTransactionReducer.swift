import Foundation
import RefdsRedux

public final class AddTransactionReducer: RefdsReduxReducerProtocol {
    public typealias State = AddTransactionStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? AddTransactionAction {
        case let .updateCategories(categories, isEmptyCategories):
            state.categories = categories
            state.category = categories.first
            state.isEmptyCategories = isEmptyCategories
            if let category = categories.first {
                state.remaining = category.budget - (category.spend + state.amount)
            }
        case let .updateError(error):
            state.error = error
        case .dismiss, .save, .fetchCategories, .addCategory, .addBudget, nil:
            break
        }
        
        return state
    }
}
