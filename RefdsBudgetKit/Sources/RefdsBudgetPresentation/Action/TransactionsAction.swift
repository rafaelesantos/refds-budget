import Foundation
import RefdsRedux
import RefdsBudgetData

public enum TransactionsAction: RefdsReduxAction {
    case fetchData
    case fetchTransactionForEdit(UUID)
    
    case updateData(
        transactions: [[TransactionRowViewDataProtocol]],
        categories: [String],
        tags: [String],
        page: Int,
        canChangePage: Bool
    )
    case updateBalance(BalanceRowViewDataProtocol)
    case updateError(RefdsBudgetError)
    case updateStatus(UUID)
    case updateShareText(String)
    case updateShare(URL)
    
    case addTransaction(AddTransactionStateProtocol?)
    case removeTransaction(UUID)
    case removeTransactions(Set<UUID>)
    
    case shareText(Set<UUID>)
    case share(Set<UUID>)
}
