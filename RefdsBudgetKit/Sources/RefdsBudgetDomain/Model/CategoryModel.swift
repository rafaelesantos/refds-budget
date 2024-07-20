import Foundation
import CoreData
import RefdsShared

public protocol CategoryModelProtocol {
    var budgets: [UUID] { get set }
    var color: String { get set }
    var id: UUID { get set }
    var name: String { get set }
    var icon: String { get set }
    
    func getEntity(for context: NSManagedObjectContext) -> CategoryEntity
}

public struct CategoryModel: CategoryModelProtocol, RefdsModel {
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
    
    public init(entity: CategoryEntity) {
        self.budgets = entity.budgets
        self.color = entity.color
        self.id = entity.id
        self.name = entity.name
        self.icon = entity.icon
    }
    
    public func getEntity(for context: NSManagedObjectContext) -> CategoryEntity {
        let request = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        guard let entity = try? context.fetch(request).first else { 
            return CategoryEntity(model: self, for: context)
        }
        return entity
    }
}
