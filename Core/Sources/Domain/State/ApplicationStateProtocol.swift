import SwiftUI
import RefdsRedux
import RefdsRouter

public protocol ApplicationStateProtocol: RefdsReduxState {
    var navigationItem: NavigationItem? { get set }
    
    var profileRouter: RefdsRouterRedux<ApplicationRouteItem> { get set }
    var categoriesRouter: RefdsRouterRedux<ApplicationRouteItem> { get set }
    var transactionsRouter: RefdsRouterRedux<ApplicationRouteItem> { get set }
    var homeRouter: RefdsRouterRedux<ApplicationRouteItem> { get set }
    var settingsRouter: RefdsRouterRedux<ApplicationRouteItem> { get set }
    
    var addBudgetState: AddBudgetStateProtocol { get set }
    var addCategoryState: AddCategoryStateProtocol { get set }
    var categoryState: CategoryStateProtocol { get set }
    var categoriesState: CategoriesStateProtocol { get set }
    var addTransactionState: AddTransactionStateProtocol { get set }
    var transactionsState: TransactionsStateProtocol { get set }
    var tagsState: TagsStateProtocol { get set }
    var homeState: HomeStateProtocol { get set }
    var settingsState: SettingsStateProtocol { get set }
    var importState: ImportStateProtocol? { get set }
    var budgetSelectionState: BudgetSelectionStateProtocol { get set }
    var budgetComparisonState: BudgetComparisonStateProtocol { get set }
}
