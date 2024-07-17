import Foundation
import RefdsRedux
import RefdsBudgetData

public enum AddTransactionAction: RefdsReduxAction {
    case updateCategories(CategoryRowViewDataProtocol?, [CategoryRowViewDataProtocol], Bool)
    case updateError(RefdsBudgetError)
    case fetchCategories(Date, Double)
    case save(Double, String)
    case addCategory
    case addBudget(Date?)
    case dismiss
}
