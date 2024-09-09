import Foundation
import RefdsRedux
import RefdsBudgetDomain

public enum AddTransactionAction: RefdsReduxAction {
    case updateCategories(CategoryRowViewDataProtocol?, [CategoryRowViewDataProtocol])
    case updateTags([TagRowViewDataProtocol])
    case updateError(RefdsBudgetError)
    case fetchCategories(Date, Double)
    case fetchTags(String)
    case save(Double, String)
}
