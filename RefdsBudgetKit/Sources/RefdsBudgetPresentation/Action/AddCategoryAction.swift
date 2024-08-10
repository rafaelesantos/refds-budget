import Foundation
import SwiftUI
import RefdsRedux
import RefdsBudgetData

public enum AddCategoryAction: RefdsReduxAction {
    case updateCategroy(AddCategoryStateProtocol)
    case updateError(RefdsBudgetError)
    case save(AddCategoryStateProtocol)
    case dismiss
}
