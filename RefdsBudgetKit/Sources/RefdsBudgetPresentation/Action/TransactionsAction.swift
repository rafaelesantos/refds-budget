import Foundation
import RefdsRedux
import RefdsBudgetData

public enum TransactionsAction: RefdsReduxAction {
    case fetchData
    case fetchTransactionForEdit(UUID)
    
    case updateData(
        transactions: [[TransactionRowViewDataProtocol]],
        categories: [String],
        tags: [String]
    )
    case updateBalance(BalanceRowViewDataProtocol)
    case updateError(RefdsBudgetError)
    case updateStatus(UUID)
    
    case addTransaction(AddTransactionStateProtocol?)
    case removeTransaction(UUID)
    case copyTransactions(Set<UUID>)
    case removeTransactions(Set<UUID>)
}
