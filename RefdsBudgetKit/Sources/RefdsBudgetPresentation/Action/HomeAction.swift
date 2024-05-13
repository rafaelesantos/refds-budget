import Foundation
import RefdsRedux

public enum HomeAction: RefdsReduxAction {
    case fetchData
    case updateData(
        remaining: [CategoryRowViewDataProtocol],
        tags: [TagRowViewDataProtocol],
        largestPurchase: [TransactionRowViewDataProtocol],
        pendingCleared: PendingClearedSectionViewDataProtocol,
        tagsMenu: [String],
        categoriesMenu: [String]
    )
    
    case updateBalance(
        balance: BalanceRowViewDataProtocol,
        remainingBalace: BalanceRowViewDataProtocol
    )
    
    case manageTags
    case showSettings
}
