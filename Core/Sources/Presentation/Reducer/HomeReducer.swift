import Foundation
import RefdsRedux
import Domain

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
            pendingCleared
        ):
            state.remaining = remaining
            state.tagsRow = tags
            state.largestPurchase = largestPurchase
            state.pendingCleared = pendingCleared
            state.isLoading = false
        case let .updateBalance(balance, remainingBalace):
            state.balance = balance
            state.remainingBalance = remainingBalace
        case let .updateFilterItems(items):
            state.filter.items = items
        default: break
        }
        
        return state
    }
}
