import Foundation
import RefdsRedux

public enum TransactionsAction: RefdsReduxAction {
    case fetchData
    case fetchTransactionForEdit(UUID)
    
    case updateData(
        transactions: [[TransactionItemViewDataProtocol]],
        page: Int,
        canChangePage: Bool
    )
    
    case updateBalance(BalanceViewDataProtocol)
    case updateFilterItems([FilterItem])
    case updateStatus(UUID)
    case updateError(RefdsBudgetError)
    case updateShareText(String)
    case updateShare(URL)
    
    case addTransaction(AddTransactionStateProtocol?)
    case removeTransaction(UUID)
    case removeTransactions(Set<UUID>)
    
    case shareText(Set<UUID>)
    case share(Set<UUID>)
}
