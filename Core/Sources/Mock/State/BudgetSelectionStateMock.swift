import Foundation
import Domain

public struct BudgetSelectionStateMock: BudgetSelectionStateProtocol {
    public var budgetsSelected: Set<UUID> = []
    public var budgets: [[BudgetItemViewDataProtocol]] = (1 ... 5).map { _ in
        (1 ... 5).map { _ in BudgetItemViewDataMock() }
    }
    public var hasAI: Bool = .random()
    public var canShowComparison: Bool = false
    public var error: RefdsBudgetError?
    
    public init() {}
}
