import Foundation
import RefdsBudgetData

public struct CategoriesStateMock: CategoriesStateProtocol {
    public var isLoading: Bool = true
    public var searchText: String = ""
    public var isFilterEnable: Bool = .random()
    public var date: Date = .current
    public var categories: [CategoryRowViewDataProtocol] = (1 ... 4).map { _ in CategoryRowViewDataMock() }
    public var isEmptyCategories: Bool = false
    public var isEmptyBudgets: Bool = false
    public var balance: BalanceRowViewDataProtocol? = BalanceRowViewDataMock()
    public var error: RefdsBudgetError? = Bool.random() ? nil : .notFoundCategory
    
    public init() {}
}
