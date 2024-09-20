import Foundation
import Domain

struct CategoriesState: CategoriesStateProtocol {
    var isLoading: Bool
    var filter: FilterViewDataProtocol
    var categories: [CategoryItemViewDataProtocol]
    var categoriesWithoutBudget: [CategoryItemViewDataProtocol]
    var isEmptyCategories: Bool
    var balance: BalanceViewDataProtocol?
    var error: RefdsBudgetError?
    
    init(
        isLoading: Bool = true,
        filter: FilterViewDataProtocol = FilterViewData(items: [.date]),
        categories: [CategoryItemViewDataProtocol] = [],
        categoriesWithoutBudget: [CategoryItemViewDataProtocol] = [],
        isEmptyCategories: Bool = true,
        balance: BalanceViewDataProtocol? = nil,
        error: RefdsBudgetError? = nil
    ) {
        self.isLoading = isLoading
        self.filter = filter
        self.categories = categories
        self.categoriesWithoutBudget = categoriesWithoutBudget
        self.isEmptyCategories = isEmptyCategories
        self.balance = balance
        self.error = error
    }
}
