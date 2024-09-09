import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsBudgetDomain

public protocol CategoryStateProtocol: RefdsReduxState {
    var id: UUID? { get set }
    var isLoading: Bool { get set }
    var description: String? { get set }
    var filter: FilterViewDataProtocol { get set }
    var category: CategoryRowViewDataProtocol? { get set }
    var budgets: [BudgetRowViewDataProtocol] { get set }
    var error: RefdsBudgetError? { get set }
}

public struct CategoryState: CategoryStateProtocol {
    public var id: UUID?
    public var isLoading: Bool
    public var description: String?
    public var filter: FilterViewDataProtocol
    public var category: CategoryRowViewDataProtocol?
    public var budgets: [BudgetRowViewDataProtocol]
    public var error: RefdsBudgetError?
    
    public init(
        id: UUID? = nil,
        isLoading: Bool = true,
        description: String? = nil,
        filter: FilterViewDataProtocol = FilterViewData(amountPage: 4, items: []),
        category: CategoryRowViewDataProtocol? = nil,
        budgets: [BudgetRowViewDataProtocol] = []
    ) {
        self.id = id
        self.isLoading = isLoading
        self.description = description
        self.filter = filter
        self.category = category
        self.budgets = budgets
    }
}
