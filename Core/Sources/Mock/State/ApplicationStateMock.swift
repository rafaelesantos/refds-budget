import SwiftUI
import RefdsRouter
import Domain

public struct ApplicationStateMock: ApplicationStateProtocol {
    public var navigationItem: NavigationItem? = .categories
    public var profileRouter: RefdsRouterRedux<ApplicationRouteItem> = .init(isPresented: .constant(.none))
    public var categoriesRouter: RefdsRouterRedux<ApplicationRouteItem> = .init(isPresented: .constant(.none))
    public var transactionsRouter: RefdsRouterRedux<ApplicationRouteItem> = .init(isPresented: .constant(.none))
    public var homeRouter: RefdsRouterRedux<ApplicationRouteItem> = .init(isPresented: .constant(.none))
    public var settingsRouter: RefdsRouterRedux<ApplicationRouteItem> = .init(isPresented: .constant(.none))
    public var addBudgetState: AddBudgetStateProtocol = AddBudgetStateMock()
    public var addCategoryState: AddCategoryStateProtocol = AddCategoryStateMock()
    public var categoryState: CategoryStateProtocol = CategoryStateMock()
    public var categoriesState: CategoriesStateProtocol = CategoriesStateMock()
    public var addTransactionState: AddTransactionStateProtocol = AddTransactionStateMock()
    public var transactionsState: TransactionsStateProtocol = TransactionsStateMock()
    public var tagsState: TagsStateProtocol = TagsStateMock()
    public var homeState: HomeStateProtocol = HomeStateMock()
    public var settingsState: SettingsStateProtocol = SettingsStateMock()
    public var importState: ImportStateProtocol? = ImportStateMock()
    public var budgetSelectionState: BudgetSelectionStateProtocol = BudgetSelectionStateMock()
    public var budgetComparisonState: BudgetComparisonStateProtocol = BudgetComparisonStateMock()
    
    public init() {}
}
