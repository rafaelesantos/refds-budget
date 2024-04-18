import Foundation
import RefdsRedux

public final class TransactionsReducer: RefdsReduxReducerProtocol {
    public typealias State = TransactionsStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? TransactionsAction {
        case .fetchData:
            state.isLoading = !state.isFilterEnable
        case let .updateData(transactions):
            state.transactions = transactions
            state.isLoading = false
        case let .updateBalance(balance):
            state.balance = balance
        case let .updateError(error):
            state.error = error
        case nil, 
                .fetchTransactionForEdit,
                .addTransaction,
                .removeTransaction,
                .removeTransactions,
                .copyTransactions:
            break
        }
        
        return state
    }
}
