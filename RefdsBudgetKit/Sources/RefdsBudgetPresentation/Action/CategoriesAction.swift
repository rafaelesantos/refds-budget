import Foundation
import RefdsRedux
import RefdsBudgetData

public enum CategoriesAction: RefdsReduxAction {
    case updateError(RefdsBudgetError)
    case updateCategories([CategoryRowViewDataProtocol], Bool)
    case updateBalance(BalanceRowViewDataProtocol)
    
    case fetchData(Date?)
    case fetchBalance(Date?)
    case fetchBudgetForEdit(Date, UUID, UUID)
    case fetchCategoryForEdit(UUID)
    
    case addCategory(AddCategoryStateProtocol?)
    case addBudget(AddBudgetStateProtocol?, Date?)
    
    case removeBudget(Date, UUID)
    case removeCategory(Date?, UUID)
    
    case showCategory(UUID)
}
