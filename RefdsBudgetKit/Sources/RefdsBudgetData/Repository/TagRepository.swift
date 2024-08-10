import Foundation
import SwiftUI
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class TagRepository: TagUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getTags() -> [TagModelProtocol] {
        database.viewContext.performAndWait {
            let request = BubbleEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            guard let entities = try? database.viewContext.fetch(request) else { return [] }
            return entities.map { TagModel(entity: $0) }
        }
    }
    
    public func getTag(by id: UUID) -> TagModelProtocol? {
        database.viewContext.performAndWait {
            let request = BubbleEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            guard let entity = try? database.viewContext.fetch(request).first else { return nil }
            return TagModel(entity: entity)
        }
    }
    
    public func removeTag(id: UUID) throws {
        try database.viewContext.performAndWait {
            guard let model = getTag(by: id) else { return }
            let entity = model.getEntity(for: self.database.viewContext)
            self.database.viewContext.delete(entity)
            try self.database.viewContext.save()
        }
    }
    
    public func addTag(
        id: UUID,
        name: String,
        color: Color,
        icon: String
    ) throws {
        try database.viewContext.performAndWait {
            guard let model = getTag(by: id) else {
                let entity = BubbleEntity(context: self.database.viewContext)
                entity.id = id
                entity.name = name
                entity.color = color.asHex
                entity.icon = icon
                try self.database.viewContext.save()
                return
            }
            let entity = model.getEntity(for: self.database.viewContext)
            entity.id = id
            entity.name = name
            entity.color = color.asHex
            entity.icon = icon
            try self.database.viewContext.save()
        }
    }
}
