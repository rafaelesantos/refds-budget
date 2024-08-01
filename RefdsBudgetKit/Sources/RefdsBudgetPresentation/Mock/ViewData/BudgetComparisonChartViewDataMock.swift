import Foundation
import SwiftUI
import RefdsShared

public struct BudgetComparisonChartViewDataMock: BudgetComparisonChartViewDataProtocol {
    public var icon: RefdsIconSymbol? = .random
    public var color: Color? = .random
    public var domain: String = .someWord()
    public var base: Double = .random(in: 500 ... 600)
    public var compare: Double = .random(in: 400 ... 800)
    public var budgetBase: Double = .random(in: 500 ... 1000)
    public var budgetCompare: Double = .random(in: 400 ... 1200)
    public var isAnimated: Bool = false
    
    public init() {}
}
