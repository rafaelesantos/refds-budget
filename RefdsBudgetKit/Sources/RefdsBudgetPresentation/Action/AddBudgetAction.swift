import Foundation
import RefdsRedux
import RefdsBudgetData

public enum AddBudgetAction: RefdsReduxAction {
    case updateCategories([CategoryStateProtocol])
    case updateBudget(UUID, Double, String)
    case updateError(RefdsBudgetError)
    case save(BudgetStateProtocol)
    case fetchBudget(Date, UUID)
    case fetchCategories
    case dismiss
}
