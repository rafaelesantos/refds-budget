import Foundation
import RefdsRedux
import RefdsBudgetDomain

public enum CategoriesAction: RefdsReduxAction {
    case fetchData
    case updateError(RefdsBudgetError)
    case updateCategories([CategoryRowViewDataProtocol], Bool)
    case updateBalance(BalanceRowViewDataProtocol)
    case removeCategory(UUID)
}
