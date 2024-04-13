import Foundation
import RefdsRedux
import RefdsBudgetData

public enum CategoriesAction: RefdsReduxAction {
    case updateError(RefdsBudgetError)
    case updateCategories([CategoryRowViewDataProtocol], Bool)
    case updateBalance(BalanceStateProtocol)
    
    case fetchData(Date?)
    case fetchBudgetForEdit(Date, UUID, UUID)
    case fetchCategoryForEdit(UUID)
    
    case addCategory(CategoryStateProtocol?)
    case addBudget(BudgetStateProtocol?, Date?)
    
    case removeBudget(Date, UUID)
    case removeCategory(Date?, UUID)
    
    case showCategoryDetail(CategoryStateProtocol)
}
