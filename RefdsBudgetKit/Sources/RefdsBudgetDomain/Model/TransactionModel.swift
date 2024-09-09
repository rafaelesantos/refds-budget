import Foundation
import CoreData
import RefdsShared

public protocol TransactionModelProtocol {
    var amount: Double { get set }
    var category: UUID { get set }
    var date: TimeInterval { get set }
    var id: UUID { get set }
    var message: String { get set }
    var status: String { get set }
    
    func getEntity(for context: NSManagedObjectContext) -> TransactionEntity
}

public struct TransactionModel: TransactionModelProtocol, RefdsModel {
    public var amount: Double
    public var category: UUID
    public var date: TimeInterval
    public var id: UUID
    public var message: String
    public var status: String
    
    public init(
        amount: Double,
        category: UUID,
        date: TimeInterval,
        id: UUID,
        message: String,
        status: String
    ) {
        self.amount = amount
        self.category = category
        self.date = date
        self.id = id
        self.message = message
        self.status = status
    }
    
    public init(entity: TransactionEntity) {
        self.amount = entity.amount
        self.category = entity.category
        self.date = entity.date
        self.id = entity.id
        self.message = entity.message
        self.status = entity.status
    }
    
    public func getEntity(for context: NSManagedObjectContext) -> TransactionEntity {
        context.performAndWait {
            let request = TransactionEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            guard let entity = try? context.fetch(request).first else {
                return TransactionEntity(model: self, for: context)
            }
            return entity
        }
    }
}
