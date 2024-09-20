import Foundation
import Domain

public struct CategoriesStateMock: CategoriesStateProtocol {
    public var isLoading: Bool = true
    public var filter: FilterViewDataProtocol = FilterViewDataMock()
    public var categories: [CategoryItemViewDataProtocol] = (1 ... 4).map { _ in CategoryItemViewDataMock() }
    public var categoriesWithoutBudget: [CategoryItemViewDataProtocol] = (1 ... 4).map { _ in CategoryItemViewDataMock() }
    public var isEmptyCategories: Bool = false
    public var isEmptyBudgets: Bool = false
    public var balance: BalanceViewDataProtocol? = BalanceViewDataMock()
    public var error: RefdsBudgetError? = Bool.random() ? nil : .notFoundCategory
    
    public init() {}
}
