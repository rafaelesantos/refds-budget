import Foundation
import RefdsRedux
import Domain

struct TransactionsState: TransactionsStateProtocol {
    var filter: FilterViewDataProtocol
    var isLoading: Bool
    var transactions: [[TransactionItemViewDataProtocol]]
    var balance: BalanceViewDataProtocol?
    var shareText: String?
    var share: URL?
    var error: RefdsBudgetError?
    
    init(
        filter: FilterViewDataProtocol = FilterViewData(items: [.date, .categories([]), .tags([]), .status([])]),
        isLoading: Bool = true,
        transactions: [[TransactionItemViewDataProtocol]] = [],
        balance: BalanceViewDataProtocol? = nil,
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
