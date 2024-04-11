import Foundation
import SwiftUI
import RefdsRedux
import RefdsBudgetData

public enum AddCategoryAction: RefdsReduxAction {
    case updateCategroy(CategoryStateProtocol)
    case updateError(RefdsBudgetError)
    case save(CategoryStateProtocol)
    case fetchCategory(CategoryStateProtocol)
    case dismiss
}
