import Foundation
import RefdsShared

public protocol BudgetModelProtocol: RefdsModel {
    var amount: Double { get set }
    var category: UUID { get set }
    var date: TimeInterval { get set }
    var id: UUID { get set }
    var message: String? { get set }
}

public struct BudgetModel: BudgetModelProtocol {
    public var amount: Double
    public var category: UUID
    public var date: TimeInterval
    public var id: UUID
    public var message: String?
    
    public init(
        amount: Double,
        category: UUID,
        date: TimeInterval,
        id: UUID,
        message: String?
    ) {
        self.amount = amount
        self.category = category
        self.date = date
        self.id = id
        self.message = message
    }
}
