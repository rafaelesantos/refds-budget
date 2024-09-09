import Foundation
import RefdsRedux
import RefdsShared
import RefdsBudgetDomain
import RefdsBudgetData

public protocol TransactionsStateProtocol: RefdsReduxState {
    var filter: FilterViewDataProtocol { get set }
    var isLoading: Bool { get set }
    var transactions: [[TransactionRowViewDataProtocol]] { get set }
    var balance: BalanceRowViewDataProtocol? { get set }
    var shareText: String? { get set }
    var share: URL? { get set }
    var error: RefdsBudgetError? { get set }
}

public struct TransactionsState: TransactionsStateProtocol {
    public var filter: FilterViewDataProtocol
    public var isLoading: Bool
    public var transactions: [[TransactionRowViewDataProtocol]]
    public var balance: BalanceRowViewDataProtocol?
    public var shareText: String?
    public var share: URL?
    public var error: RefdsBudgetError?
    
    public init(
        filter: FilterViewDataProtocol = FilterViewData(items: [.date, .categories([]), .tags([]), .status([])]),
        isLoading: Bool = true,
        transactions: [[TransactionRowViewDataProtocol]] = [],
        balance: BalanceRowViewDataProtocol? = nil,
        shareText: String? = nil,
        share: URL? = nil,
        error: RefdsBudgetError? = nil
    ) {
        self.filter = filter
        self.isLoading = isLoading
        self.transactions = transactions
        self.balance = balance
        self.shareText = shareText
        self.share = share
        self.error = error
    }
}
