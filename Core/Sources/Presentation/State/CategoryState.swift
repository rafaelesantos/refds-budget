import Foundation
import Domain

struct CategoryState: CategoryStateProtocol {
    var id: UUID?
    var isLoading: Bool
    var description: String?
    var filter: FilterViewDataProtocol
    var category: CategoryItemViewDataProtocol?
    var budgets: [BudgetItemViewDataProtocol]
    var error: RefdsBudgetError?
    
    init(
        id: UUID? = nil,
        isLoading: Bool = true,
        description: String? = nil,
        filter: FilterViewDataProtocol = FilterViewData(amountPage: 4, items: []),
        category: CategoryItemViewDataProtocol? = nil,
        budgets: [BudgetItemViewDataProtocol] = []
    ) {
        self.id = id
        self.isLoading = isLoading
        self.description = description
        self.filter = filter
        self.category = category
        self.budgets = budgets
    }
}
