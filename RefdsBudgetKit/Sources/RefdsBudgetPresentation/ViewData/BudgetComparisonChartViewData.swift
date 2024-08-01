import Foundation
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

public struct BudgetComparisonChartViewData: BudgetComparisonChartViewDataProtocol {
    public var icon: RefdsIconSymbol?
    public var color: Color?
    public var domain: String
    public var base: Double
    public var compare: Double
    public var budgetBase: Double
    public var budgetCompare: Double
    public var isAnimated: Bool
    
    public init(
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
