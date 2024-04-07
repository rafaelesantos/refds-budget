import Foundation
import CoreData

@objc(TransactionEntity)
public class TransactionEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: UUID
    @NSManaged public var date: TimeInterval
    @NSManaged public var id: UUID
    @NSManaged public var message: String
}
