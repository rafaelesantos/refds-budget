import SwiftUI
import RefdsRouter

public struct ApplicationStateMock: ApplicationStateProtocol {
    public var router: RefdsRouterRedux<ApplicationRoute> = .init(isPresented: .constant(.none))
    public var addBudgetState: BudgetStateProtocol = AddBudgetStateMock()
    public var addCategoryState: CategoryStateProtocol = AddCategoryStateMock()
    public var categoriesState: CategoriesStateProtocol = CategoriesStateMock()
    
    public init() {}
}
