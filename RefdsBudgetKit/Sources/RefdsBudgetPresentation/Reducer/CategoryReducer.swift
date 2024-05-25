import Foundation
import RefdsRedux

public final class CategoryReducer: RefdsReduxReducerProtocol {
    public typealias State = CategoryStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? CategoryAction {
        case .fetchData:
            state.isLoading = !state.isFilterEnable
        case .share, .shareText:
            state.isLoading = true
        case let .updateData(name, icon, color, budgets, transactions, page, canChangePage):
            state.name = name
            state.icon = icon
            state.color = color
            state.budgtes = budgets
            state.transactions = transactions
            state.page = page
            state.canChangePage = canChangePage
            state.isLoading = false
        case let .updateBalance(balance):
            state.balance = balance
        case let .updateError(error):
            state.error = error
        case let .updateShareText(text):
            state.shareText = text
            state.isLoading = false
        case let .updateShare(url):
            state.share = url
            state.isLoading = false
        default: break
        }
        
        return state
    }
}
