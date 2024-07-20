import Foundation
import SwiftUI
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class BudgetRepositoryMock: BudgetUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getAllBudgets() -> [BudgetModelProtocol] {
        (1 ... 100).map { _ in BudgetModelMock() }
    }
    
    public func getBudgets(on category: UUID) -> [BudgetModelProtocol] {
        getAllBudgets()
    }
    
    public func getBudgets(from date: Date) -> [BudgetModelProtocol] {
        getAllBudgets()
    }
    
    public func getBudget(by id: UUID) -> BudgetModelProtocol? {
        BudgetModelMock()
    }
    
    public func getBudget(
        on category: UUID,
        from date: Date
    ) -> BudgetModelProtocol? {
        BudgetModelMock()
    }
    
    public func removeBudget(id: UUID) throws {}
    
    public func addBudget(
        id: UUID,
        amount: Double,
        date: Date,
        message: String?,
        category: UUID
    ) throws {}
}
