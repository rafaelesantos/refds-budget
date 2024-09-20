import Foundation
import RefdsRedux

public protocol BudgetComparisonStateProtocol: RefdsReduxState {
    var hasAI: Bool { get set }
    var baseBudgetDate: String? { get set }
    var compareBudgetDate: String? { get set }
    var baseBudget: BudgetItemViewDataProtocol? { get set }
    var compareBudget: BudgetItemViewDataProtocol? { get set }
    var selectedCategory: BudgetComparisonChartViewDataProtocol? { get set }
    var categoriesChart: [BudgetComparisonChartViewDataProtocol] { get set }
    var selectedTag: BudgetComparisonChartViewDataProtocol? { get set }
    var tagsChart: [BudgetComparisonChartViewDataProtocol] { get set }
    var isLoading: Bool { get set }
    var error: RefdsBudgetError? { get set }
}
