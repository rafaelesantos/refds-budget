import Foundation
import SwiftUI
import RefdsRedux
import RefdsBudgetData

public enum AddCategoryAction: RefdsReduxAction {
    case updateName(String)
    case updateColor(Color)
    case updateIcon(String)
    case updateBudgets([AddBudgetStateProtocol])
    case updateError(RefdsBudgetError)
    case dismiss
    case save
}
