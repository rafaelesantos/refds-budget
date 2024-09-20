import Foundation
import RefdsRedux

public protocol TransactionsStateProtocol: RefdsReduxState {
    var filter: FilterViewDataProtocol { get set }
    var isLoading: Bool { get set }
    var transactions: [[TransactionItemViewDataProtocol]] { get set }
    var balance: BalanceViewDataProtocol? { get set }
    var shareText: String? { get set }
    var share: URL? { get set }
    var error: RefdsBudgetError? { get set }
}
