import Foundation
import CoreData

@objc(CategoryEntity)
public class CategoryEntity: NSManagedObject, CategoryModelProtocol {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var budgets: [UUID]
    @NSManaged public var color: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var icon: String
    
    public convenience init(
        model: CategoryModelProtocol,
        for context: NSManagedObjectContext
    ) {
        self.init(context: context)
        budgets = model.budgets
        color = model.color
        id = model.id
        name = model.name
        icon = model.icon
    }
    
    public func getEntity(for context: NSManagedObjectContext) -> CategoryEntity {
        self
    }
}
