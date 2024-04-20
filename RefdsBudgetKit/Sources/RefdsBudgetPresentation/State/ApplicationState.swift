import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsRouter
import RefdsBudgetData

public protocol ApplicationStateProtocol: RefdsReduxState {
    var itemNavigation: ItemNavigation? { get set }
    var categoriesRouter: RefdsRouterRedux<ApplicationRoute> { get set }
    var transactionsRouter: RefdsRouterRedux<ApplicationRoute> { get set }
    var homeRouter: RefdsRouterRedux<ApplicationRoute> { get set }
    var addBudgetState: AddBudgetStateProtocol { get set }
    var addCategoryState: AddCategoryStateProtocol { get set }
    var categoryState: CategoryStateProtocol { get set }
    var categoriesState: CategoriesStateProtocol { get set }
    var addTransaction: AddTransactionStateProtocol { get set }
    var transactions: TransactionsStateProtocol { get set }
    var tags: TagsStateProtocol { set get }
}

public struct ApplicationState: ApplicationStateProtocol {
    public var itemNavigation: ItemNavigation?
    public var categoriesRouter: RefdsRouterRedux<ApplicationRoute>
    public var transactionsRouter: RefdsRouterRedux<ApplicationRoute>
    public var homeRouter: RefdsRouterRedux<ApplicationRoute>
    public var addBudgetState: AddBudgetStateProtocol
    public var addCategoryState: AddCategoryStateProtocol
    public var categoryState: CategoryStateProtocol
    public var categoriesState: CategoriesStateProtocol
    public var addTransaction: AddTransactionStateProtocol
    public var transactions: TransactionsStateProtocol
    public var tags: TagsStateProtocol
    
    public init(
        itemNavigation: ItemNavigation? = .categories,
        categoriesRouter: RefdsRouterRedux<ApplicationRoute> = .init(isPresented: .constant(.none)),
        transactionsRouter: RefdsRouterRedux<ApplicationRoute> = .init(isPresented: .constant(.none)),
        homeRouter: RefdsRouterRedux<ApplicationRoute> = .init(isPresented: .constant(.none)),
        addBudgetState: AddBudgetStateProtocol = AddBudgetState(),
        addCategoryState: AddCategoryStateProtocol = AddCategoryState(),
        categoryState: CategoryStateProtocol = CategoryState(),
        categoriesState: CategoriesStateProtocol = CategoriesState(),
        addTransaction: AddTransactionStateProtocol = AddTransactionState(),
        transactions: TransactionsStateProtocol = TransactionsState(),
        tags: TagsStateProtocol = TagsState()
    ) {
        self.itemNavigation = itemNavigation
        self.categoriesRouter = categoriesRouter
        self.transactionsRouter = transactionsRouter
        self.homeRouter = homeRouter
        self.addBudgetState = addBudgetState
        self.addCategoryState = addCategoryState
        self.categoryState = categoryState
        self.categoriesState = categoriesState
        self.addTransaction = addTransaction
        self.transactions = transactions
        self.tags = tags
    }
}
