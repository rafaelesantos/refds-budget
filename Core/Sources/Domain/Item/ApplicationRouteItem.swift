import SwiftUI
import RefdsRedux
import RefdsRouter
import RefdsInjection

public enum ApplicationRouteItem: RefdsRoutableRedux {
    case addBudget
    case addCategory
    case addTransaction
    case category
    case categories
    case home
    case manageTags
    case settings
    case `import`
    case budgetSelection
    case budgetComparison
    case transactions
    
    public var navigationType: RefdsNavigationType {
        switch self {
        default: return .push
        }
    }
    
    private var viewFactory: ViewFactoryProtocol {
        RefdsContainer.resolve(type: ViewFactoryProtocol.self)
    }
    
    private func bindingState(_ state: Binding<RefdsReduxState>) -> Binding<ApplicationStateProtocol>? {
        guard let wrappedValue = state.wrappedValue as? ApplicationStateProtocol else { return nil }
        return Binding { wrappedValue } set: {
            state.wrappedValue = $0
        }
    }
    
    @ViewBuilder
    public func view(
        router: RefdsRouterRedux<ApplicationRouteItem>,
        state: Binding<RefdsReduxState>,
        action: @escaping (RefdsReduxAction) -> Void
    ) -> some View {
        if let state = bindingState(state) {
            switch self {
            case .addBudget: AnyView(viewFactory.makeAddBudgetView(state: state.addBudgetState, action: action))
            case .addCategory: AnyView(viewFactory.makeAddCategoryView(state: state.addCategoryState, action: action))
            case .addTransaction: AnyView(viewFactory.makeAddTransactionView(state: state.addTransactionState, action: action))
            case .category: AnyView(viewFactory.makeCategoryView(state: state.categoryState, action: action))
            case .categories: AnyView(viewFactory.makeCategoriesView(state: state.categoriesState, action: action))
            case .home: AnyView(viewFactory.makeHomeView(state: state.homeState, action: action))
            case .manageTags: AnyView(viewFactory.makeTagView(state: state.tagsState, action: action))
            case .settings: AnyView(viewFactory.makeSettingsView(state: state.settingsState, action: action))
            case .import: AnyView(viewFactory.makeImportView(state: state.importState, action: action))
            case .budgetSelection: AnyView(viewFactory.makeBudgetSelectionView(state: state.budgetSelectionState, action: action))
            case .budgetComparison: AnyView(viewFactory.makeBudgetComparisonView(state: state.budgetComparisonState, action: action))
            case .transactions: AnyView(viewFactory.makeTransactionsView(state: state.transactionsState, action: action))
            }
        }
    }
}
