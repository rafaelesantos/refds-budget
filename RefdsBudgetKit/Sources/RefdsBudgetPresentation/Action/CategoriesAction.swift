import Foundation
import RefdsRedux
import RefdsBudgetData

public enum CategoriesAction: RefdsReduxAction {
    case updateError(RefdsBudgetError)
    case updateCategories([CategoryRowViewDataProtocol], Bool, [String])
    case updateBalance(BalanceRowViewDataProtocol)
    
    case fetchData(Date?, Set<String>)
    case fetchBudgetForEdit(Date, UUID, UUID)
    case fetchCategoryForEdit(UUID)
    
    case addCategory(AddCategoryStateProtocol?)
    case addBudget(AddBudgetStateProtocol?, Date?)
    
    case removeBudget(Date, UUID)
    case removeCategory(Date?, UUID)
    
    case showCategory(UUID)
}
