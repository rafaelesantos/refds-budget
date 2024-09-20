import Foundation
import Domain

struct BudgetSelectionState: BudgetSelectionStateProtocol {
    var budgetsSelected: Set<UUID>
    var budgets: [[BudgetItemViewDataProtocol]]
    var hasAI: Bool
    var canShowComparison: Bool
    var error: RefdsBudgetError?
    
    init(
        budgetsSelected: Set<UUID> = [],
        budgets: [[BudgetItemViewDataProtocol]] = [],
        hasAI: Bool = false,
        canShowComparison: Bool = false,
        error: RefdsBudgetError? = nil
    ) {
        self.budgetsSelected = budgetsSelected
        self.budgets = budgets
        self.hasAI = hasAI
        self.canShowComparison = canShowComparison
        self.error = error
    }
}
