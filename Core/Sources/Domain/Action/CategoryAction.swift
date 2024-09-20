import SwiftUI
import RefdsRedux

public enum CategoryAction: RefdsReduxAction {
    case fetchData
    case removeBudget(UUID)
    case removeCategory(UUID)
    case updateError(RefdsBudgetError)
    case updateData(
        description: String?,
        category: CategoryItemViewDataProtocol,
        budgets: [BudgetItemViewDataProtocol],
        canChangePage: Bool
    )
}
