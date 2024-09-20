import Foundation
import RefdsRedux

public enum AddBudgetAction: RefdsReduxAction {
    case fetchData
    case fetchBudget
    case save
    case updateError(RefdsBudgetError)
    case updateBudget(
        id: UUID,
        description: String,
        amount: Double
    )
    case updateData(
        id: UUID,
        description: String,
        date: Date,
        amount: Double,
        category: CategoryItemViewDataProtocol?,
        categories: [CategoryItemViewDataProtocol]
    )
}
