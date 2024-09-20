import SwiftUI
import RefdsRedux
import RefdsRouter
import Domain

public struct ApplicationState: ApplicationStateProtocol {
    public var navigationItem: NavigationItem? = .home
    public var profileRouter: RefdsRouterRedux<ApplicationRouteItem> = .init(isPresented: .constant(.none))
    public var categoriesRouter: RefdsRouterRedux<ApplicationRouteItem> = .init(isPresented: .constant(.none))
    public var transactionsRouter: RefdsRouterRedux<ApplicationRouteItem> = .init(isPresented: .constant(.none))
    public var homeRouter: RefdsRouterRedux<ApplicationRouteItem> = .init(isPresented: .constant(.none))
    public var settingsRouter: RefdsRouterRedux<ApplicationRouteItem> = .init(isPresented: .constant(.none))
    public var addBudgetState: AddBudgetStateProtocol = AddBudgetState()
    public var addCategoryState: AddCategoryStateProtocol = AddCategoryState()
    public var categoryState: CategoryStateProtocol = CategoryState()
    public var categoriesState: CategoriesStateProtocol = CategoriesState()
    public var addTransactionState: AddTransactionStateProtocol = AddTransactionState()
    public var transactionsState: TransactionsStateProtocol = TransactionsState()
    public var tagsState: TagsStateProtocol = TagsState()
    public var homeState: HomeStateProtocol = HomeState()
    public var settingsState: SettingsStateProtocol = SettingsState()
    public var importState: ImportStateProtocol?
    public var budgetSelectionState: BudgetSelectionStateProtocol = BudgetSelectionState()
    public var budgetComparisonState: BudgetComparisonStateProtocol = BudgetComparisonState()
    
    public init() {}
}

private struct ApplicationStateEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<ApplicationState>?
}

public extension EnvironmentValues {
    var applicationState: Binding<ApplicationState>? {
        get { self[ApplicationStateEnvironmentKey.self] }
        set { self[ApplicationStateEnvironmentKey.self] = newValue }
    }
}
