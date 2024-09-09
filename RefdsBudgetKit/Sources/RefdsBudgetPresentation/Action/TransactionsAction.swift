import Foundation
import RefdsRedux
import RefdsBudgetDomain
import RefdsBudgetData

public enum TransactionsAction: RefdsReduxAction {
    case fetchData
    case fetchTransactionForEdit(UUID)
    
    case updateData(
        transactions: [[TransactionRowViewDataProtocol]],
        page: Int,
        canChangePage: Bool
    )
    
    case updateBalance(BalanceRowViewDataProtocol)
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
