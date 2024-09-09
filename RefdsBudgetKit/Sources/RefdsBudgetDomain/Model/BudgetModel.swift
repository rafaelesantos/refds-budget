import Foundation
import CoreData
import RefdsShared

public protocol BudgetModelProtocol {
    var amount: Double { get set }
    var category: UUID { get set }
    var date: TimeInterval { get set }
    var id: UUID { get set }
    var message: String? { get set }
    
    func getEntity(for context: NSManagedObjectContext) -> BudgetEntity
}

public struct BudgetModel: BudgetModelProtocol, RefdsModel {
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
    
    public init(entity: BudgetEntity) {
        self.amount = entity.amount
        self.category = entity.category
        self.date = entity.date
        self.id = entity.id
        self.message = entity.message
    }
    
    public func getEntity(for context: NSManagedObjectContext) -> BudgetEntity {
        context.performAndWait {
            let request = BudgetEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            guard let entity = try? context.fetch(request).first else {
                return BudgetEntity(model: self, for: context)
            }
            return entity
        }
    }
}
