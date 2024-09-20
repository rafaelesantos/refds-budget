import Foundation
import Domain

public struct CategoryStateMock: CategoryStateProtocol {
    public var id: UUID? = .init()
    public var isLoading: Bool = true
    public var description: String?
    public var filter: FilterViewDataProtocol = FilterViewDataMock()
    public var category: CategoryItemViewDataProtocol? = CategoryItemViewDataMock()
    public var budgets: [BudgetItemViewDataProtocol] = (1 ... 3).map { _ in BudgetItemViewDataMock() }
    public var error: RefdsBudgetError? = Bool.random() ? nil : .notFoundBudget
    
    public init() {}
}
