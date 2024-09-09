import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsBudgetDomain

public struct BudgetSelectionStateMock: BudgetSelectionStateProtocol {
    public var budgetsSelected: Set<UUID> = []
    public var budgets: [[BudgetRowViewDataProtocol]] = (1 ... 5).map { _ in
        (1 ... 5).map { _ in BudgetRowViewDataMock() }
    }
    public var hasAI: Bool = .random()
    public var canShowComparison: Bool = false
    public var error: RefdsBudgetError?
    
    public init() {}
}
