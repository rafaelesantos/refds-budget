import SwiftUI
import RefdsInjection
import Domain

public final class CategoryRepositoryMock: CategoryUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getAllCategories() -> [CategoryModelProtocol] {
        (1 ... 20).map { _ in CategoryModelMock() }
    }
    
    public func getCategories(from date: Date) -> [CategoryModelProtocol] {
        getAllCategories()
    }
    
    public func getCategory(by id: UUID) -> CategoryModelProtocol? {
        CategoryModelMock()
    }
    
    public func removeCategory(id: UUID) throws {}
    
    public func addCategory(
        id: UUID,
        name: String,
        color: Color,
        budgets: [UUID],
        icon: String
    ) throws {}
}
