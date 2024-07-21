import Foundation
import RefdsRedux
import RefdsBudgetData

public enum BudgetSelectionAction: RefdsReduxAction {
    case updateCategories([[BudgetRowViewDataProtocol]])
    case fetchData
    case showComparison
    case addBudget
}
