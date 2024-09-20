import SwiftUI
import RefdsInjection
import Domain

public final class TagRepositoryMock: TagUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getTags() -> [TagModelProtocol] {
        (1 ... 20).map { _ in TagModelMock() }
    }
    
    public func getTag(by id: UUID) -> TagModelProtocol? {
        TagModelMock()
    }
    
    public func removeTag(id: UUID) throws {}
    
    public func addTag(
        id: UUID,
        name: String,
        color: Color,
        icon: String
    ) throws {}
}
