import Foundation
import RefdsRedux
import RefdsShared
import RefdsBudgetData

public protocol TransactionsStateProtocol: RefdsReduxState {
    var date: Date { get set }
    var isFilterEnable: Bool { get set }
    var isLoading: Bool { get set }
    var searchText: String { get set }
    var transactions: [[TransactionRowViewDataProtocol]] { get set }
    var balance: BalanceRowViewDataProtocol? { get set }
    var error: RefdsBudgetError? { get set }
}

public struct TransactionsState: TransactionsStateProtocol {
    public var date: Date
    public var isFilterEnable: Bool
    public var isLoading: Bool
    public var searchText: String
    public var transactions: [[TransactionRowViewDataProtocol]]
    public var balance: BalanceRowViewDataProtocol?
    public var error: RefdsBudgetError?
    
    public init(
        date: Date = .current,
        isFilterEnable: Bool = true,
        isLoading: Bool = true,
        searchText: String = "",
        transactions: [[TransactionRowViewDataProtocol]] = [],
        error: RefdsBudgetError? = nil
    ) {
        self.date = date
        self.isFilterEnable = isFilterEnable
        self.isLoading = isLoading
        self.searchText = searchText
        self.transactions = transactions
        self.error = error
    }
}