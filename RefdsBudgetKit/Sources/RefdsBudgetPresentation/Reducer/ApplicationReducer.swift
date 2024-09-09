import Foundation
import RefdsRedux

public final class ApplicationReducer: RefdsReduxReducerProtocol {
    public typealias State = ApplicationStateProtocol
    
    public init() {}
    
    public lazy var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        state.addBudgetState = AddBudgetReducer().reduce(state.addBudgetState, action)
        state.addCategoryState = AddCategoryReducer().reduce(state.addCategoryState, action)
        state.categoriesState = CategoriesReducer().reduce(state.categoriesState, action)
        state.categoryState = CategoryReducer().reduce(state.categoryState, action)
        state.addTransactionState = AddTransactionReducer().reduce(state.addTransactionState, action)
        state.transactionsState = TransactionsReducer().reduce(state.transactionsState, action)
        state.tagsState = TagReducer().reduce(state.tagsState, action)
        state.homeState = HomeReducer().reduce(state.homeState, action)
        state.settingsState = SettingsReducer().reduce(state.settingsState, action)
        state.budgetSelectionState = BudgetSelectionReducer().reduce(state.budgetSelectionState, action)
        state.budgetComparisonState = BudgetComparisonReducer().reduce(state.budgetComparisonState, action)
        
        if let importState = state.importState {
            state.importState = ImportReducer().reduce(importState, action)
        }
        
        switch action {
        case let action as TransactionsAction:
            state = self.handler(with: state, for: action)
        default: break
        }
        
        return state
    }
    
    private func handler(
        with state: State,
        for action: TransactionsAction
    ) -> State {
        var state: State = state
        switch action {
        case let .addTransaction(transaction):
            state.addTransactionState = transaction ?? AddTransactionState()
        default:
            break
        }
        return state
    }
}
