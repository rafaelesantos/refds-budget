import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsBudgetData

public protocol CategoryStateProtocol: RefdsReduxState {
    var id: UUID { get set }
    var name: String { get set }
    var color: Color { get set }
    var icon: String { get set }
    var canSave: Bool { get }
    var error: RefdsBudgetError? { get set }
}

public struct AddCategoryState: CategoryStateProtocol {
    public var id: UUID
    public var name: String
    public var color: Color
    public var icon: String
    public var error: RefdsBudgetError?
    
    public var canSave: Bool {
        name.count > 2
    }
    
    public init(
        id: UUID = .init(),
        name: String = "",
        color: Color = .accentColor,
        icon: String = RefdsIconSymbol.dollarsign.rawValue
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
    }
}
