import Foundation
import SwiftUI
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class LocalBubbleRepository: BubbleUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getBubbles() -> [BubbleEntity] {
        let request = BubbleEntity.fetchRequest()
        guard let bubble = try? database.viewContext.fetch(request) else { return [] }
        return bubble
    }
    
    public func getBubble(by id: UUID) -> BubbleEntity? {
        let request = BubbleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        guard let bubble = try? database.viewContext.fetch(request).first else { return nil }
        return bubble
    }
    
    public func removeBubble(id: UUID) throws {
        guard let bubble = getBubble(by: id) else { return }
        database.viewContext.delete(bubble)
        try database.viewContext.save()
    }
    
    public func addBubble(id: UUID, name: String, color: Color) throws {
        guard let bubble = getBubble(by: id) else {
            let bubble = BubbleEntity(context: database.viewContext)
            bubble.id = id
            bubble.name = name.uppercased()
            bubble.color = color.asHex()
            try database.viewContext.save()
            return
        }
        bubble.id = id
        bubble.name = name.uppercased()
        bubble.color = color.asHex()
        try database.viewContext.save()
    }
}
