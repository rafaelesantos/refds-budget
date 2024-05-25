import Foundation
import RefdsShared

public protocol CategoryModelProtocol: RefdsModel {
    var budgets: [UUID] { get set }
    var color: String { get set }
    var id: UUID { get set }
    var name: String { get set }
    var icon: String { get set }
}

public struct CategoryModel: CategoryModelProtocol {
    public var budgets: [UUID]
    public var color: String
    public var id: UUID
    public var name: String
    public var icon: String
    
    public init(
        budgets: [UUID],
        color: String,
        id: UUID,
        name: String,
        icon: String
    ) {
        self.budgets = budgets
        self.color = color
        self.id = id
        self.name = name
        self.icon = icon
    }
}
