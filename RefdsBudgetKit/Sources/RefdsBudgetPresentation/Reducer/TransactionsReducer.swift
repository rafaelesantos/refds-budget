import Foundation
import RefdsRedux

public final class TransactionsReducer: RefdsReduxReducerProtocol {
    public typealias State = TransactionsStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? TransactionsAction {
        case .fetchData:
            state.isLoading = true
        case let .updateData(transactions, categories, tags, page, canChangePage):
            state.transactions = transactions
            state.categories = categories
            state.tags = tags
            state.page = page
            state.canChangePage = canChangePage
            state.isLoading = false
        case let .updateBalance(balance):
            state.balance = balance
        case let .updateError(error):
            state.error = error
        default:
            break
        }
        
        return state
    }
}
