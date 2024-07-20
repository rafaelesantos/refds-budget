import Foundation
import CoreData

@objc(BudgetEntity)
public class BudgetEntity: NSManagedObject, BudgetModelProtocol {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetEntity> {
        return NSFetchRequest<BudgetEntity>(entityName: "BudgetEntity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: UUID
    @NSManaged public var date: TimeInterval
    @NSManaged public var id: UUID
    @NSManaged public var message: String?
    
    public convenience init(
        model: BudgetModelProtocol,
        for context: NSManagedObjectContext
    ) {
        self.init(context: context)
        amount = model.amount
        category = model.category
        date = model.date
        id = model.id
        message = model.message
    }
    
    public func getEntity(for context: NSManagedObjectContext) -> BudgetEntity {
        self
    }
}
