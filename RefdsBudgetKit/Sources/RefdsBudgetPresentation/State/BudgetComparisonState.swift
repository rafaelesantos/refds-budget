import Foundation
import RefdsRedux
import RefdsShared
import RefdsBudgetDomain

public protocol BudgetComparisonStateProtocol: RefdsReduxState {
    var hasAI: Bool { get set }
    var baseBudgetDate: String? { get set }
    var compareBudgetDate: String? { get set }
    var baseBudget: BudgetRowViewDataProtocol? { get set }
    var compareBudget: BudgetRowViewDataProtocol? { get set }
    var selectedCategory: BudgetComparisonChartViewDataProtocol? { get set }
    var categoriesChart: [BudgetComparisonChartViewDataProtocol] { get set }
    var selectedTag: BudgetComparisonChartViewDataProtocol? { get set }
    var tagsChart: [BudgetComparisonChartViewDataProtocol] { get set }
    var isLoading: Bool { get set }
    var error: RefdsBudgetError? { get set }
}

public struct BudgetComparisonState: BudgetComparisonStateProtocol {
    public var hasAI: Bool
    public var baseBudgetDate: String?
    public var compareBudgetDate: String?
    public var baseBudget: BudgetRowViewDataProtocol?
    public var compareBudget: BudgetRowViewDataProtocol?
    public var selectedCategory: BudgetComparisonChartViewDataProtocol?
    public var categoriesChart: [BudgetComparisonChartViewDataProtocol]
    public var selectedTag: BudgetComparisonChartViewDataProtocol?
    public var tagsChart: [BudgetComparisonChartViewDataProtocol]
    public var isLoading: Bool
    public var error: RefdsBudgetError?
    
    public init(
        hasAI: Bool = false,
        baseBudgetDate: String? = nil,
        compareBudgetDate: String? = nil,
        baseBudget: BudgetRowViewDataProtocol? = nil,
        compareBudget: BudgetRowViewDataProtocol? = nil,
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
