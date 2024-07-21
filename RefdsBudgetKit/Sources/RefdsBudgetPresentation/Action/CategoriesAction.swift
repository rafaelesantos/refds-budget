import Foundation
import RefdsRedux
import RefdsBudgetData

public enum CategoriesAction: RefdsReduxAction {
    case updateError(RefdsBudgetError)
    case updateCategories([CategoryRowViewDataProtocol], Bool, [String])
    case updateBalance(BalanceRowViewDataProtocol)
    
    case fetchData
    case fetchCategoryForEdit(UUID)
    
    case addCategory(AddCategoryStateProtocol?)
    case addBudget
    case removeCategory(Date?, UUID)
    
    case showCategory(UUID, Date?)
}
