import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsBudgetData

public protocol BudgetComparisonStateProtocol: RefdsReduxState {
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
    public var baseBudget: BudgetRowViewDataProtocol?
    public var compareBudget: BudgetRowViewDataProtocol?
    public var selectedCategory: BudgetComparisonChartViewDataProtocol?
    public var categoriesChart: [BudgetComparisonChartViewDataProtocol] = []
    public var selectedTag: BudgetComparisonChartViewDataProtocol?
    public var tagsChart: [BudgetComparisonChartViewDataProtocol] = []
    public var isLoading: Bool = true
    public var error: RefdsBudgetError?
    
    public init() {}
}
