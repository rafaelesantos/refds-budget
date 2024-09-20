import Foundation
import SwiftUI

public protocol BudgetUseCase {
    func getAllBudgets() -> [BudgetModelProtocol]
    func getBudgets(on category: UUID) -> [BudgetModelProtocol]
    func getBudgets(from date: Date) -> [BudgetModelProtocol]
    
    func getBudget(by id: UUID) -> BudgetModelProtocol?
    func getBudget(on category: UUID, from date: Date) -> BudgetModelProtocol?
    
    func removeBudget(id: UUID) throws
    
    func addBudget(
        id: UUID,
        amount: Double,
        date: Date,
        message: String?,
        category: UUID
    ) throws
}
