import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsBudgetDomain

public protocol BudgetSelectionStateProtocol: RefdsReduxState {
    var budgetsSelected: Set<UUID> { get set }
    var budgets: [[BudgetRowViewDataProtocol]] { get set }
    var hasAI: Bool { get set }
    var canShowComparison: Bool { get set }
    var error: RefdsBudgetError? { get set }
}

public struct BudgetSelectionState: BudgetSelectionStateProtocol {
    public var budgetsSelected: Set<UUID>
    public var budgets: [[BudgetRowViewDataProtocol]]
    public var hasAI: Bool
    public var canShowComparison: Bool
    public var error: RefdsBudgetError?
    
    public init(
        budgetsSelected: Set<UUID> = [],
        budgets: [[BudgetRowViewDataProtocol]] = [],
        hasAI: Bool = false,
        canShowComparison: Bool = false,
        error: RefdsBudgetError? = nil
    ) {
        self.budgetsSelected = budgetsSelected
        self.budgets = budgets
        self.hasAI = hasAI
        self.canShowComparison = canShowComparison
        self.error = error
    }
}
