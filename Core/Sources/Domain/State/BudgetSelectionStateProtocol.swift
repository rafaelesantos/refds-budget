import Foundation
import RefdsRedux

public protocol BudgetSelectionStateProtocol: RefdsReduxState {
    var budgetsSelected: Set<UUID> { get set }
    var budgets: [[BudgetItemViewDataProtocol]] { get set }
    var hasAI: Bool { get set }
    var canShowComparison: Bool { get set }
    var error: RefdsBudgetError? { get set }
}
