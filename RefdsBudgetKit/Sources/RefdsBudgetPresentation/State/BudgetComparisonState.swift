import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsBudgetData

public protocol BudgetComparisonStateProtocol: RefdsReduxState {
    var budgetsSelected: Set<UUID> { get set }
    var budgets: [[BudgetRowViewDataProtocol]] { get set }
    var canShowComparison: Bool { get set }
    var error: RefdsBudgetError? { get set }
}

public struct BudgetComparisonState: BudgetComparisonStateProtocol {
    public var budgetsSelected: Set<UUID> = []
    public var budgets: [[BudgetRowViewDataProtocol]] = []
    public var canShowComparison: Bool = false
    public var error: RefdsBudgetError?
    
    public init() {}
}
