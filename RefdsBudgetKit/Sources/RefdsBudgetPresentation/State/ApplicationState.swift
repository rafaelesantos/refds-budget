import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsRouter
import RefdsBudgetData

public protocol ApplicationStateProtocol: RefdsReduxState {
    var router: RefdsRouterRedux<ApplicationRoute> { get set }
    var addBudgetState: BudgetStateProtocol { get set }
    var addCategoryState: CategoryStateProtocol { get set }
    var categoriesState: CategoriesStateProtocol { get set }
}

public struct ApplicationState: ApplicationStateProtocol {
    public var router: RefdsRouterRedux<ApplicationRoute>
    public var addBudgetState: BudgetStateProtocol
    public var addCategoryState: CategoryStateProtocol
    public var categoriesState: CategoriesStateProtocol
    
    public init(
        router: RefdsRouterRedux<ApplicationRoute> = .init(isPresented: .constant(.none)),
        addBudgetState: BudgetStateProtocol = AddBudgetState(),
        addCategoryState: CategoryStateProtocol = AddCategoryState(),
        categoriesState: CategoriesStateProtocol = CategoriesState()
    ) {
        self.router = router
        self.addBudgetState = addBudgetState
        self.addCategoryState = addCategoryState
        self.categoriesState = categoriesState
    }
}
