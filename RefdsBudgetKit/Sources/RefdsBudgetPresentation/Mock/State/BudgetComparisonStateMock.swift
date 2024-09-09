import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsBudgetDomain

public struct BudgetComparisonStateMock: BudgetComparisonStateProtocol {
    public var hasAI: Bool = .random()
    public var baseBudgetDate: String?
    public var compareBudgetDate: String?
    public var baseBudget: BudgetRowViewDataProtocol? = BudgetRowViewDataMock()
    public var compareBudget: BudgetRowViewDataProtocol? = BudgetRowViewDataMock()
    public var selectedCategory: BudgetComparisonChartViewDataProtocol?
    public var categoriesChart: [BudgetComparisonChartViewDataProtocol] = (1 ... 5).map { _ in BudgetComparisonChartViewDataMock() }
    public var selectedTag: BudgetComparisonChartViewDataProtocol?
    public var tagsChart: [BudgetComparisonChartViewDataProtocol] = (1 ... 5).map { _ in BudgetComparisonChartViewDataMock() }
    public var isLoading: Bool = true
    public var error: RefdsBudgetError?
    
    public init() {}
}
