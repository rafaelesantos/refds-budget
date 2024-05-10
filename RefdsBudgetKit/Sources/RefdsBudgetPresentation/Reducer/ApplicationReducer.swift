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
        
        switch action {
        case let action as CategoriesAction:
            state = self.handler(with: state, for: action)
        case let action as CategoryAction:
            state = self.handler(with: state, for: action)
        case let action as AddTransactionAction:
            state = self.handler(with: state, for: action)
        case let action as TransactionsAction:
            state = self.handler(with: state, for: action)
        case let action as HomeAction:
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
            state.addTransactionState = transaction ?? AddTransactionState()
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
            state.addTransactionState = transaction ?? AddTransactionState()
        default:
            break
        }
        return state
    }
    
    private func handler(
        with state: State,
        for action: HomeAction
    ) -> State {
        var state: State = state
        switch action {
        case .manageTags:
            state.tagsState = TagsState()
        case .showSettings:
            state.settingsState = SettingsState()
        default:
            break
        }
        return state
    }
}
