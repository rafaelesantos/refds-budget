import Foundation
import RefdsRedux

public enum HomeAction: RefdsReduxAction {
    case fetchData
    case updateFilterItems([FilterItem])
    case updateBalance(
        balance: BalanceViewDataProtocol,
        remainingBalace: BalanceViewDataProtocol
    )
    case updateData(
        remaining: [CategoryItemViewDataProtocol],
        tags: [TagItemViewDataProtocol],
        largestPurchase: [TransactionItemViewDataProtocol],
        pendingCleared: PendingClearedViewDataProtocol
    )
}
