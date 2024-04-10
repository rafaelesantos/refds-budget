import Foundation
import SwiftUI
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class LocalBubbleRepositoryMock: BubbleUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getBubbles() -> [BubbleEntity] {
        (1 ... 20).map { _ in BubbleEntityMock.value(for: database.viewContext) }
    }
    
    public func getBubble(by id: UUID) -> BubbleEntity? {
        BubbleEntityMock.value(for: database.viewContext)
    }
    
    public func removeBubble(id: UUID) throws {}
    
    public func addBubble(id: UUID, name: String, color: Color) throws {}
}
