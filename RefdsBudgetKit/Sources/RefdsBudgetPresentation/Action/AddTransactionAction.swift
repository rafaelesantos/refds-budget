import Foundation
import RefdsRedux
import RefdsBudgetData

public enum AddTransactionAction: RefdsReduxAction {
    case updateCategories(CategoryRowViewDataProtocol?, [CategoryRowViewDataProtocol], Bool)
    case updateTags([TagRowViewDataProtocol])
    case updateError(RefdsBudgetError)
    case fetchCategories(Date, Double)
    case fetchTags(String)
    case save(Double, String)
    case addCategory
    case addBudget(Date?)
    case dismiss
}
