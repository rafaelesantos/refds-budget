import Foundation
import RefdsRedux
import RefdsBudgetData

public enum CategoriesAction: RefdsReduxAction {
    case updateError(RefdsBudgetError)
    case updateCategories([CategoryStateProtocol])
    case updateCurrentValues(CurrentValuesStateProtocol)
    case editCategory(CategoryStateProtocol)
    case editBudget(BudgetStateProtocol)
    case categoryDetail(CategoryStateProtocol)
    case fetchCategories(Date?)
    case addCategory
    case addBudget
}
