import Foundation
import Domain

public struct TransactionsStateMock: TransactionsStateProtocol {
    public var filter: FilterViewDataProtocol = FilterViewDataMock()
    public var isLoading: Bool = true
    public var transactions: [[TransactionItemViewDataProtocol]] = [(1 ... 5).map { _ in TransactionItemViewDataMock() }]
    public var balance: (BalanceViewDataProtocol)? = BalanceViewDataMock()
    public var shareText: String?
    public var share: URL?
    public var error: RefdsBudgetError? = nil
    
    public init() {}
}
