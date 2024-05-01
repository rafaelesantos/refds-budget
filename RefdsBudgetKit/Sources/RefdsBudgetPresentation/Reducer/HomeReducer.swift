import Foundation
import RefdsRedux

public final class HomeReducer: RefdsReduxReducerProtocol {
    public typealias State = HomeStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? HomeAction {
        case .fetchData:
            state.isLoading = true
            
        case let .updateData(
            remaining,
            tags,
            largestPurchase,
            tagsMenu,
            categoriesMenu
        ):
            state.remaining = remaining
            state.tagsRow = tags
            state.largestPurchase = largestPurchase
            state.tags = tagsMenu
            state.categories = categoriesMenu
            state.isLoading = false
            
        case let .updateBalance(balance, remainingBalace):
            state.balance = balance
            state.remainingBalance = remainingBalace
            
        default: break
        }
        
        return state
    }
}
