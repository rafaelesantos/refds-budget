import Foundation
import RefdsRedux

public enum HomeAction: RefdsReduxAction {
    case fetchData(Date?)
    case updateData(
        remaining: [CategoryRowViewDataProtocol],
        tags: [TagRowViewDataProtocol],
        largestPurchase: [TransactionRowViewDataProtocol],
        tagsMenu: [String],
        categoriesMenu: [String]
    )
    
    case updateBalance(
        balance: BalanceRowViewDataProtocol,
        remainingBalace: BalanceRowViewDataProtocol
    )
    
    case manageTags
}
