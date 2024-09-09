import SwiftUI
import RefdsShared
import RefdsBudgetDomain

public struct CategoryStateMock: CategoryStateProtocol {
    public var id: UUID? = .init()
    public var isLoading: Bool = true
    public var description: String?
    public var filter: FilterViewDataProtocol = FilterViewData()
    public var category: CategoryRowViewDataProtocol? = CategoryRowViewDataMock()
    public var budgets: [BudgetRowViewDataProtocol] = (1 ... 3).map { _ in BudgetRowViewDataMock() }
    public var error: RefdsBudgetError? = Bool.random() ? nil : .notFoundBudget
    
    public init() {}
}
