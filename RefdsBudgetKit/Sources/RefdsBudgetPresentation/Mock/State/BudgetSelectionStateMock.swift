import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsBudgetData

public struct BudgetSelectionStateMock: BudgetSelectionStateProtocol {
    public var budgetsSelected: Set<UUID> = []
    public var budgets: [[BudgetRowViewDataProtocol]] = (1 ... 5).map { _ in
        (1 ... 5).map { _ in BudgetRowViewDataMock() }
    }
    public var canShowComparison: Bool = false
    public var error: RefdsBudgetError?
    
    public init() {}
}
