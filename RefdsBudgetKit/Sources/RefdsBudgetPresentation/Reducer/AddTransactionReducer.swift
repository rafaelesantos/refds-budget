import Foundation
import RefdsRedux

public final class AddTransactionReducer: RefdsReduxReducerProtocol {
    public typealias State = AddTransactionStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? AddTransactionAction {
        case .fetchCategories:
            state.isLoading = true
        case let .updateCategories(category, categories):
            state.categories = categories
            state.category = category ?? categories.first
            if let category = state.category {
                state.remaining = category.budget - (category.spend + state.amount)
            }
            state.isLoading = false
        case let .updateTags(tags):
            state.tags = tags
        case let .updateError(error):
            state.error = error
            state.isLoading = false
        case .save, .fetchTags, nil:
            break
        }
        
        return state
    }
}
