import Foundation
import RefdsRedux

public protocol CategoryStateProtocol: RefdsReduxState {
    var id: UUID? { get set }
    var isLoading: Bool { get set }
    var description: String? { get set }
    var filter: FilterViewDataProtocol { get set }
    var category: CategoryItemViewDataProtocol? { get set }
    var budgets: [BudgetItemViewDataProtocol] { get set }
    var error: RefdsBudgetError? { get set }
}
