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
        state.addTransaction = AddTransactionReducer().reduce(state.addTransaction, action)
        state.transactions = TransactionsReducer().reduce(state.transactions, action)
        
        switch action {
        case let action as CategoriesAction:
            state = self.handler(with: state, for: action)
        case let action as CategoryAction:
            state = self.handler(with: state, for: action)
        case let action as AddTransactionAction:
            state = self.handler(with: state, for: action)
        case let action as TransactionsAction:
            state = self.handler(with: state, for: action)
        default: break
        }
        
        return state
    }
    
    private func handler(
        with state: State,
        for action: CategoriesAction
    ) -> State {
        var state: State = state
        switch action {
        case let .showCategory(categoryId):
            state.categoryState = CategoryState(id: categoryId)
        case let .addCategory(category):
            state.addCategoryState = category ?? AddCategoryState()
        case let .addBudget(budget, date):
            state.addBudgetState = budget ?? AddBudgetState(month: date ?? .current)
        default:
            break
        }
        return state
    }
    
    private func handler(
        with state: State,
        for action: CategoryAction
    ) -> State {
        var state: State = state
        switch action {
        case let .editCategory(category):
            state.addCategoryState = category
        case let .editBudget(budget, _):
            state.addBudgetState = budget
        case let .addTransaction(transaction):
            state.addTransaction = transaction ?? AddTransactionState()
        default:
            break
        }
        return state
    }
    
    private func handler(
        with state: State,
        for action: AddTransactionAction
    ) -> State {
        var state: State = state
        switch action {
        case .addCategory:
            state.addCategoryState = AddCategoryState()
        case let .addBudget(date):
            state.addBudgetState = AddBudgetState(month: date ?? .current)
        default:
            break
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
            state.addTransaction = transaction ?? AddTransactionState()
        default:
            break
        }
        return state
    }
}
