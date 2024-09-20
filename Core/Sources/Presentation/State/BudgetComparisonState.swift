import Foundation
import Domain

struct BudgetComparisonState: BudgetComparisonStateProtocol {
    var hasAI: Bool
    var baseBudgetDate: String?
    var compareBudgetDate: String?
    var baseBudget: BudgetItemViewDataProtocol?
    var compareBudget: BudgetItemViewDataProtocol?
    var selectedCategory: BudgetComparisonChartViewDataProtocol?
    var categoriesChart: [BudgetComparisonChartViewDataProtocol]
    var selectedTag: BudgetComparisonChartViewDataProtocol?
    var tagsChart: [BudgetComparisonChartViewDataProtocol]
    var isLoading: Bool
    var error: RefdsBudgetError?
    
    init(
        hasAI: Bool = false,
        baseBudgetDate: String? = nil,
        compareBudgetDate: String? = nil,
        baseBudget: BudgetItemViewDataProtocol? = nil,
        compareBudget: BudgetItemViewDataProtocol? = nil,
        selectedCategory: BudgetComparisonChartViewDataProtocol? = nil,
        categoriesChart: [BudgetComparisonChartViewDataProtocol] = [],
        selectedTag: BudgetComparisonChartViewDataProtocol? = nil,
        tagsChart: [BudgetComparisonChartViewDataProtocol] = [],
        isLoading: Bool = true,
        error: RefdsBudgetError? = nil
    ) {
        self.hasAI = hasAI
        self.baseBudgetDate = baseBudgetDate
        self.compareBudgetDate = compareBudgetDate
        self.baseBudget = baseBudget
        self.compareBudget = compareBudget
        self.selectedCategory = selectedCategory
        self.categoriesChart = categoriesChart
        self.selectedTag = selectedTag
        self.tagsChart = tagsChart
        self.isLoading = isLoading
        self.error = error
    }
}
