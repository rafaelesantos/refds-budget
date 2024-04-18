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
        case let .updateData(name, icon, color, budgets, transactions):
            state.name = name
            state.icon = icon
            state.color = color
            state.budgtes = budgets
            state.transactions = transactions
            state.isLoading = false
        case let .updateBalance(balance):
            state.balance = balance
        case let .updateError(error):
            state.error = error
        case nil,
                .editBudget,
                .editCategory,
                .removeBudget,
                .removeCategory,
                .fetchBudgetForEdit,
                .fetchCategoryForEdit,
                .fetchTransactionForEdit,
                .addTransaction,
                .removeTransaction,
                .copyTransactions,
                .removeTransactions:
            break
        }
        
        return state
    }
}
