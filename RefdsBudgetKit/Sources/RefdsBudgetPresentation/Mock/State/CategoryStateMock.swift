import Foundation
import SwiftUI
import RefdsShared
import RefdsBudgetData

public struct CategoryStateMock: CategoryStateProtocol {
    public var id: UUID = .init()
    public var name: String = .someWord()
    public var color: Color = .random
    public var icon: String = RefdsIconSymbol.random.rawValue
    public var date: Date = .current
    public var isFilterEnable: Bool = true
    public var page: Int = 1
    public var canChangePage: Bool = false
    public var isLoading: Bool = true
    public var searchText: String = ""
    public var budgtes: [BudgetRowViewDataProtocol] = (1 ... 3).map { _ in BudgetRowViewDataMock() }
    public var transactions: [[TransactionRowViewDataProtocol]] = [(1 ... 5).map { _ in TransactionRowViewDataMock() }]
    public var balance: BalanceRowViewDataProtocol? = BalanceRowViewDataMock()
    public var shareText: String?
    public var share: URL?
    public var paginationDaysAmount: Int = 2
    public var error: RefdsBudgetError? = Bool.random() ? nil : .notFoundBudget
    
    public init() {}
}
