import SwiftUI
import RefdsRedux
import RefdsBudgetDomain

public enum CategoryAction: RefdsReduxAction {
    case fetchData
    case removeBudget(UUID)
    case removeCategory(UUID)
    case updateError(RefdsBudgetError)
    case updateData(
        description: String?,
        category: CategoryRowViewDataProtocol,
        budgets: [BudgetRowViewDataProtocol],
        canChangePage: Bool
    )
}
