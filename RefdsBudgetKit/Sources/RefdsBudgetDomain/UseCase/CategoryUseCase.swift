import Foundation
import SwiftUI

public protocol CategoryUseCase {
    func getAllCategories() -> [CategoryEntity]
    func getAllBudgets() -> [BudgetEntity]
    
    func getCategories(from date: Date) -> [CategoryEntity]
    func getCategory(by id: UUID) -> CategoryEntity?
    
    func getBudget(by id: UUID) -> BudgetEntity?
    func getBudgets(by ids: [UUID]) -> [BudgetEntity]
    func getBudgets(from date: Date) -> [BudgetEntity]
    func getBudgets(on category: UUID) -> [BudgetEntity]
    func getBudget(on category: UUID, from date: Date) -> BudgetEntity?
    
    func removeCategory(id: UUID) throws
    func removeBudget(id: UUID) throws
    
    func addCategory(
        id: UUID,
        name: String,
        color: Color,
        budgets: [UUID],
        icon: String
    ) throws
    
    func addBudget(
        id: UUID,
        amount: Double,
        date: Date,
        message: String?,
        category: UUID
    ) throws
}
