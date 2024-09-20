import Foundation
import RefdsRedux

public protocol HomeStateProtocol: RefdsReduxState {
    var isLoading: Bool { get set }
    var filter: FilterViewDataProtocol { get set }
    var balance: BalanceViewDataProtocol? { get set }
    var remainingBalance: BalanceViewDataProtocol? { get set }
    var remaining: [CategoryItemViewDataProtocol] { get set }
    var tagsRow: [TagItemViewDataProtocol] { get set }
    var largestPurchase: [TransactionItemViewDataProtocol] { get set }
    var pendingCleared: PendingClearedViewDataProtocol? { get set }
    var selectedTag: TagItemViewDataProtocol? { get set }
    var selectedRemaining: CategoryItemViewDataProtocol? { get set }
    var error: RefdsBudgetError? { get set }
}
