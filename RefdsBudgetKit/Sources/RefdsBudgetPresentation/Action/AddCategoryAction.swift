import Foundation
import SwiftUI
import RefdsShared
import RefdsRedux
import RefdsBudgetDomain

public enum AddCategoryAction: RefdsReduxAction {
    case fetchData
    case updateError(RefdsBudgetError)
    case save
    case updateData(
        id: UUID,
        name: String,
        color: Color,
        icon: RefdsIconSymbol
    )
}
