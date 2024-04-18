import SwiftUI
import RefdsRedux
import RefdsBudgetData

public enum CategoryAction: RefdsReduxAction {
    case fetchData(Date?, UUID, String)
    case fetchBudgetForEdit(Date, UUID, UUID)
    case fetchCategoryForEdit(UUID)
    case fetchTransactionForEdit(UUID)
    
    case updateData(
        name: String,
        icon: String,
        color: Color,
        budgets: [BudgetRowViewDataProtocol],
        transactions: [[TransactionRowViewDataProtocol]]
    )
    case updateBalance(BalanceRowViewDataProtocol)
    case updateError(RefdsBudgetError)
    
    case editBudget(AddBudgetStateProtocol, Date)
    case editCategory(AddCategoryStateProtocol)
    case addTransaction(AddTransactionStateProtocol?)
    
    case removeBudget(Date, UUID)
    case removeCategory(Date?, UUID)
    case removeTransaction(UUID)
    
    case copyTransactions(Set<UUID>)
    case removeTransactions(Set<UUID>)
}
