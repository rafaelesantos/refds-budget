import Foundation
import RefdsRedux
import RefdsBudgetData

public enum AddTransactionAction: RefdsReduxAction {
    case updateCategories([CategoryRowViewDataProtocol], Bool)
    case updateError(RefdsBudgetError)
    case fetchCategories(Date)
    case save
    case addCategory
    case addBudget(Date?)
    case dismiss
}
