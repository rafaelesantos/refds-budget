import Foundation
import RefdsRedux
import RefdsBudgetData

public enum TransactionsAction: RefdsReduxAction {
    case fetchData(Date?, String, Set<String>, Set<String>)
    case fetchTransactionForEdit(UUID)
    
    case updateData(
        transactions: [[TransactionRowViewDataProtocol]],
        categories: [String],
        tags: [String]
    )
    case updateBalance(BalanceRowViewDataProtocol)
    case updateError(RefdsBudgetError)
    
    case addTransaction(AddTransactionStateProtocol?)
    case removeTransaction(UUID)
    case copyTransactions(Set<UUID>)
    case removeTransactions(Set<UUID>)
}
