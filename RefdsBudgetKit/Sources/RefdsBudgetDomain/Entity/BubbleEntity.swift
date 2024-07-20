import Foundation
import CoreData

@objc(BubbleEntity)
public class BubbleEntity: NSManagedObject, TagModelProtocol {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BubbleEntity> {
        return NSFetchRequest<BubbleEntity>(entityName: "BubbleEntity")
    }

    @NSManaged public var color: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var icon: String
    
    public convenience init(
        model: TagModelProtocol,
        for context: NSManagedObjectContext
    ) {
        self.init(context: context)
        color = model.color
        id = model.id
        name = model.name
        icon = model.icon
    }
    
    public func getEntity(for context: NSManagedObjectContext) -> BubbleEntity {
        self
    }
}
