import Foundation
import RefdsRedux

public final class TransactionsReducer: RefdsReduxReducerProtocol {
    public typealias State = TransactionsStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? TransactionsAction {
        case .fetchData, .shareText, .share:
            state.isLoading = true
        case let .updateData(transactions, page, canChangePage):
            state.transactions = transactions
            state.filter.currentPage = page
            state.filter.canChangePage = canChangePage
            state.isLoading = false
        case let .updateBalance(balance):
            state.balance = balance
        case let .updateFilterItems(items):
            state.filter.items = items
        case let .updateError(error):
            state.error = error
        case let .updateShareText(text):
            state.shareText = text
            state.isLoading = false
        case let .updateShare(url):
            state.share = url
            state.isLoading = false
        default:
            break
        }
        
        return state
    }
}
