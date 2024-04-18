import SwiftUI
import RefdsRouter

public struct ApplicationStateMock: ApplicationStateProtocol {
    public var itemNavigation: ItemNavigation? = .categories
    public var categoriesRouter: RefdsRouterRedux<ApplicationRoute> = .init(isPresented: .constant(.none))
    public var transactionsRouter: RefdsRouterRedux<ApplicationRoute> = .init(isPresented: .constant(.none))
    public var addBudgetState: AddBudgetStateProtocol = AddBudgetStateMock()
    public var addCategoryState: AddCategoryStateProtocol = AddCategoryStateMock()
    public var categoryState: CategoryStateProtocol = CategoryStateMock()
    public var categoriesState: CategoriesStateProtocol = CategoriesStateMock()
    public var addTransaction: AddTransactionStateProtocol = AddTransactionStateMock()
    public var transactions: TransactionsStateProtocol = TransactionsStateMock()
    
    public init() {}
}
