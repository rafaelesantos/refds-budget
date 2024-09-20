import SwiftUI
import RefdsShared
import RefdsRedux

public protocol AddCategoryStateProtocol: RefdsReduxState {
    var id: UUID { get set }
    var name: String { get set }
    var color: Color { get set }
    var icon: RefdsIconSymbol { get set }
    var canSave: Bool { get }
    var error: RefdsBudgetError? { get set }
}
