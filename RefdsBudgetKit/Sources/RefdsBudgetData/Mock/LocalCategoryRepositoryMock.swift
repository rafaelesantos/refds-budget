import Foundation
import SwiftUI
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class LocalCategoryRepositoryMock: CategoryUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getAllCategories() -> [CategoryEntity] {
        (1 ... 20).map { _ in CategoryEntityMock.value(for: database.viewContext) }
    }
    
    public func getAllBudgets() -> [BudgetEntity] {
        (1 ... 20).map { _ in BudgetEntityMock.value(for: database.viewContext) }
    }
    
    public func getCategories(from date: Date) -> [CategoryEntity] {
        (1 ... 20).map { _ in CategoryEntityMock.value(for: database.viewContext) }
    }
    
    public func getCategory(by id: UUID) -> CategoryEntity? {
        CategoryEntityMock.value(for: database.viewContext)
    }
    
    public func getBudget(by id: UUID) -> BudgetEntity? {
        BudgetEntityMock.value(for: database.viewContext)
    }
    
    public func getBudgets(by ids: [UUID]) -> [BudgetEntity] {
        (1 ... 20).map { _ in BudgetEntityMock.value(for: database.viewContext) }
    }
    
    public func getBudgets(on category: UUID) -> [BudgetEntity] {
        (1 ... 20).map { _ in BudgetEntityMock.value(for: database.viewContext) }
    }
    
    public func getBudget(on category: UUID, from date: Date) -> BudgetEntity? {
        BudgetEntityMock.value(for: database.viewContext)
    }
    
    public func removeCategory(id: UUID) throws {}
    
    public func removeBudget(id: UUID) throws {}
    
    public func addCategory(id: UUID, name: String, color: Color, budgets: [UUID], icon: String) throws {}
    
    public func addBudget(id: UUID, amount: Double, date: Date, message: String?, category: UUID) throws {}
}
