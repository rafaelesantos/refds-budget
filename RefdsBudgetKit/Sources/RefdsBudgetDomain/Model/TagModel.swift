import Foundation
import CoreData
import RefdsShared

public protocol TagModelProtocol {
    var color: String { get set }
    var id: UUID { get set }
    var name: String { get set }
    var icon: String { get set }
    
    func getEntity(for context: NSManagedObjectContext) -> BubbleEntity
}

public struct TagModel: TagModelProtocol, RefdsModel {
    public var color: String
    public var id: UUID
    public var name: String
    public var icon: String
    
    public init(
        color: String,
        id: UUID,
        name: String,
        icon: String
    ) {
        self.color = color
        self.id = id
        self.name = name
        self.icon = icon
    }
    
    public init(entity: BubbleEntity) {
        self.color = entity.color
        self.id = entity.id
        self.name = entity.name
        self.icon = entity.icon
    }
    
    public func getEntity(for context: NSManagedObjectContext) -> BubbleEntity {
        let request = BubbleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        guard let entity = try? context.fetch(request).first else {
            return BubbleEntity(model: self, for: context)
        }
        return entity
    }
}
