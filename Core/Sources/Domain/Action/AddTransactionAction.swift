import Foundation
import RefdsRedux

public enum AddTransactionAction: RefdsReduxAction {
    case updateCategories(CategoryItemViewDataProtocol?, [CategoryItemViewDataProtocol])
    case updateTags([TagItemViewDataProtocol])
    case updateError(RefdsBudgetError)
    case fetchCategories(Date, Double)
    case fetchTags(String)
    case save(Double, String)
}
