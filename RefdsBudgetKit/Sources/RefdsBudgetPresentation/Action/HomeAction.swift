import Foundation
import RefdsRedux
import RefdsBudgetDomain

public enum HomeAction: RefdsReduxAction {
    case fetchData
    case updateFilterItems([FilterItem])
    case updateBalance(
        balance: BalanceRowViewDataProtocol,
        remainingBalace: BalanceRowViewDataProtocol
    )
    case updateData(
        remaining: [CategoryRowViewDataProtocol],
        tags: [TagRowViewDataProtocol],
        largestPurchase: [TransactionRowViewDataProtocol],
        pendingCleared: PendingClearedSectionViewDataProtocol
    )
}
