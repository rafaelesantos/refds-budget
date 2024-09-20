import SwiftUI
import RefdsShared
import Domain

struct BudgetComparisonChartViewData: BudgetComparisonChartViewDataProtocol {
    var icon: RefdsIconSymbol?
    var color: Color?
    var domain: String
    var base: Double
    var compare: Double
    var budgetBase: Double
    var budgetCompare: Double
    var isAnimated: Bool
    
    init(
        icon: RefdsIconSymbol?,
        color: Color?,
        domain: String,
        base: Double,
        compare: Double,
        budgetBase: Double,
        budgetCompare: Double,
        isAnimated: Bool = false
    ) {
        self.icon = icon
        self.color = color
        self.domain = domain
        self.base = base
        self.compare = compare
        self.budgetBase = budgetBase
        self.budgetCompare = budgetCompare
        self.isAnimated = isAnimated
    }
}
