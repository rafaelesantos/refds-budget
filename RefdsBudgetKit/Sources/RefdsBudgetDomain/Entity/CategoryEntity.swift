import Foundation
import CoreData

@objc(CategoryEntity)
public class CategoryEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var budgets: [UUID]
    @NSManaged public var color: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var icon: String
}
