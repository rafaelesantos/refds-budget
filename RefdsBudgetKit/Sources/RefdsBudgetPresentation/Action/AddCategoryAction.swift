import Foundation
import SwiftUI
import RefdsRedux
import RefdsBudgetData

public enum AddCategoryAction: RefdsReduxAction {
    case updateBudgets([BudgetStateProtocol])
    case updateError(RefdsBudgetError)
    case save(CategoryStateProtocol)
    case dismiss
}
