import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsBudgetData

public protocol CategoryStateProtocol: RefdsReduxState {
    var id: UUID { get set }
    var name: String { get set }
    var color: Color { get set }
    var icon: String { get set }
    var date: Date { get set }
    var isFilterEnable: Bool { get set }
    var page: Int { get set }
    var canChangePage: Bool { get set }
    var isLoading: Bool { get set }
    var searchText: String { get set }
    var budgtes: [BudgetRowViewDataProtocol] { get set }
    var transactions: [[TransactionRowViewDataProtocol]] { get set }
    var balance: BalanceRowViewDataProtocol? { get set }
    var shareText: String? { get set }
    var share: URL? { get set }
    var paginationDaysAmount: Int { get set }
    var error: RefdsBudgetError? { get set }
}

public struct CategoryState: CategoryStateProtocol {
    public var id: UUID
    public var name: String
    public var color: Color
    public var icon: String
    public var date: Date
    public var isFilterEnable: Bool
    public var page: Int
    public var canChangePage: Bool
    public var isLoading: Bool = true
    public var searchText: String = ""
    public var budgtes: [BudgetRowViewDataProtocol]
    public var transactions: [[TransactionRowViewDataProtocol]]
    public var balance: BalanceRowViewDataProtocol?
    public var shareText: String?
    public var share: URL?
    public var paginationDaysAmount: Int = 2
    public var error: RefdsBudgetError?
    
    public init(
        id: UUID = .init(),
        name: String = "",
        color: Color = .accentColor,
        icon: String = RefdsIconSymbol.random.rawValue,
        date: Date = .current,
        isFilterEnable: Bool = true,
        page: Int = 1,
        canChangePage: Bool = false,
        budgtes: [BudgetRowViewDataProtocol] = [],
        transactions: [[TransactionRowViewDataProtocol]] = [],
        error: RefdsBudgetError? = nil
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
        self.date = date
        self.isFilterEnable = isFilterEnable
        self.page = page
        self.canChangePage = canChangePage
        self.budgtes = budgtes
        self.transactions = transactions
        self.error = error
    }
}
