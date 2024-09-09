import Foundation
import RefdsShared
import RefdsBudgetMock
import RefdsBudgetDomain
import RefdsBudgetData

public struct TransactionsStateMock: TransactionsStateProtocol {
    public var filter: FilterViewDataProtocol = FilterViewDataMock()
    public var isLoading: Bool = true
    public var transactions: [[TransactionRowViewDataProtocol]] = [(1 ... 5).map { _ in TransactionRowViewDataMock() }]
    public var balance: (BalanceRowViewDataProtocol)? = BalanceRowViewDataMock()
    public var shareText: String?
    public var share: URL?
    public var error: RefdsBudgetError? = nil
    
    public init() {}
}
