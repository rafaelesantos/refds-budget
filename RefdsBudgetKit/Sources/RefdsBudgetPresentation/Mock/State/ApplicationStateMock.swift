import SwiftUI
import RefdsRouter

public struct ApplicationStateMock: ApplicationStateProtocol {
    public var itemNavigation: ItemNavigation? = .categories
    public var premiumRouter: RefdsRouterRedux<ApplicationRoute> = .init(isPresented: .constant(.none))
    public var categoriesRouter: RefdsRouterRedux<ApplicationRoute> = .init(isPresented: .constant(.none))
    public var transactionsRouter: RefdsRouterRedux<ApplicationRoute> = .init(isPresented: .constant(.none))
    public var homeRouter: RefdsRouterRedux<ApplicationRoute> = .init(isPresented: .constant(.none))
    public var settingsRouter: RefdsRouterRedux<ApplicationRoute> = .init(isPresented: .constant(.none))
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
    
    public init() {}
}
