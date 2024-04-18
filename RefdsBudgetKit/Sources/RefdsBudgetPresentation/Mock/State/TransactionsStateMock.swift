import Foundation
import RefdsShared
import RefdsBudgetData

public struct TransactionsStateMock: TransactionsStateProtocol {
    public var date: Date = .current
    public var isFilterEnable: Bool = true
    public var isLoading: Bool = true
    public var searchText: String = ""
    public var transactions: [[TransactionRowViewDataProtocol]] = [(1 ... 5).map { _ in TransactionRowViewDataMock() }]
    public var balance: (BalanceRowViewDataProtocol)? = BalanceRowViewDataMock()
    public var error: RefdsBudgetError? = nil
    
    public init() {}
}
