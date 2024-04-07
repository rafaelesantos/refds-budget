import Foundation
import CoreData

@objc(BudgetEntity)
public class BudgetEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetEntity> {
        return NSFetchRequest<BudgetEntity>(entityName: "BudgetEntity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: UUID
    @NSManaged public var date: TimeInterval
    @NSManaged public var id: UUID
    @NSManaged public var message: String?
}
