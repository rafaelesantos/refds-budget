import SwiftUI
import RefdsShared

public protocol BudgetComparisonChartViewDataProtocol {
    var icon: RefdsIconSymbol? { get set }
    var color: Color? { get set }
    var domain: String { get set }
    var base: Double { get set }
    var compare: Double { get set }
    var budgetBase: Double { get set }
    var budgetCompare: Double { get set }
    var isAnimated: Bool { get set }
}
