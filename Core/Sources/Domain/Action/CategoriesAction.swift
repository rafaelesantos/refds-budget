import Foundation
import RefdsRedux

public enum CategoriesAction: RefdsReduxAction {
    case fetchData
    case updateError(RefdsBudgetError)
    case updateCategories([CategoryItemViewDataProtocol], [CategoryItemViewDataProtocol], Bool)
    case updateBalance(BalanceViewDataProtocol)
    case removeCategory(UUID)
}
