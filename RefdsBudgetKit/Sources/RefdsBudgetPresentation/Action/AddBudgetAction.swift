import Foundation
import RefdsRedux
import RefdsBudgetData

public enum AddBudgetAction: RefdsReduxAction {
    case updateCategories([AddCategoryStateProtocol], UUID, Double, String)
    case updateBudget(UUID, Double, String)
    case updateError(RefdsBudgetError)
    case save(AddBudgetStateProtocol)
    case fetchBudget(Date, UUID)
    case fetchCategories(Date)
    case dismiss
}
