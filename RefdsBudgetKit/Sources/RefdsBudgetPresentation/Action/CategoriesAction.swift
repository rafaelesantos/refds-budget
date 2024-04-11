import Foundation
import RefdsRedux
import RefdsBudgetData

public enum CategoriesAction: RefdsReduxAction {
    case updateError(RefdsBudgetError)
    case updateCategories([CategoryRowViewDataProtocol])
    case updateCurrentValues(CurrentValuesStateProtocol)
    case showEditCategory(CategoryStateProtocol)
    case showEditBudget(BudgetStateProtocol)
    case showCategoryDetail(CategoryStateProtocol)
    case fetchCategories(Date?)
    case fetchCurrentValues(Date?)
    case addCategory
    case addBudget
}
