import Foundation
import RefdsRedux

public enum BudgetSelectionAction: RefdsReduxAction {
    case updateCategories([[BudgetItemViewDataProtocol]])
    case fetchData
}
