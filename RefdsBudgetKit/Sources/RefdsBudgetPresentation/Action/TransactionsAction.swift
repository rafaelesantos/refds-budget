import Foundation
import RefdsRedux
import RefdsBudgetData

public enum TransactionsAction: RefdsReduxAction {
    case fetchData(Date?, String)
    case fetchTransactionForEdit(UUID)
    
    case updateData(transactions: [[TransactionRowViewDataProtocol]])
    case updateBalance(BalanceRowViewDataProtocol)
    case updateError(RefdsBudgetError)
    
    case addTransaction(AddTransactionStateProtocol?)
    case removeTransaction(UUID)
    case copyTransactions(Set<UUID>)
    case removeTransactions(Set<UUID>)
}
