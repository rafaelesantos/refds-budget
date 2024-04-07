import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsBudgetData

public protocol AddCategoryStateProtocol: RefdsReduxState {
    var id: UUID { get set }
    var name: String { get set }
    var color: Color { get set }
    var icon: String { get set }
    var budgets: [AddBudgetStateProtocol] { get set }
    var error: RefdsBudgetError? { get set }
}

public struct AddCategoryState: AddCategoryStateProtocol {
    public var id: UUID
    public var name: String
    public var color: Color
    public var icon: String
    public var budgets: [AddBudgetStateProtocol]
    public var error: RefdsBudgetError?
    
    public init(
        id: UUID = .init(),
        name: String = "",
        color: Color = .accentColor,
        icon: String = "",
        budgets: [AddBudgetStateProtocol] = []
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
        self.budgets = budgets
    }
}
