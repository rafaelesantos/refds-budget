import Foundation
import RefdsRedux

public protocol CategoriesStateProtocol: RefdsReduxState {
    var isLoading: Bool { get set }
    var filter: FilterViewDataProtocol { get set }
    var categories: [CategoryItemViewDataProtocol] { get set }
    var categoriesWithoutBudget: [CategoryItemViewDataProtocol] { get set }
    var isEmptyCategories: Bool { get set }
    var balance: BalanceViewDataProtocol? { get set }
    var error: RefdsBudgetError? { get set }
}
