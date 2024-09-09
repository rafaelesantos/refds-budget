import Foundation
import SwiftUI
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class BudgetRepository: BudgetUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    @RefdsInjection private var transactionRepository: TransactionUseCase
    
    public init() {}
    
    public func getAllBudgets() -> [BudgetModelProtocol] {
        database.viewContext.performAndWait {
            let request = BudgetEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            guard let entities = try? database.viewContext.fetch(request) else { return [] }
            return entities.map { BudgetModel(entity: $0) }
        }
    }
    
    public func getBudgets(on category: UUID) -> [BudgetModelProtocol] {
        database.viewContext.performAndWait {
            let request = BudgetEntity.fetchRequest()
            request.predicate = NSPredicate(format: "category = %@", category as CVarArg)
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            guard let entities = try? database.viewContext.fetch(request) else { return [] }
            return entities.map { BudgetModel(entity: $0) }
        }
    }
    
    public func getBudgets(from date: Date) -> [BudgetModelProtocol] {
        database.viewContext.performAndWait {
            return getAllBudgets().filter { budget in
                let budgetDate = budget.date.asString(withDateFormat: .monthYear)
                let currentDate = date.asString(withDateFormat: .monthYear)
                return budgetDate == currentDate
            }
        }
    }
    
    public func getBudget(by id: UUID) -> BudgetModelProtocol? {
        database.viewContext.performAndWait {
            let request = BudgetEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            guard let entity = try? database.viewContext.fetch(request).first else { return nil }
            return BudgetModel(entity: entity)
        }
    }
    
    public func getBudget(on category: UUID, from date: Date) -> BudgetModelProtocol? {
        database.viewContext.performAndWait {
            return getBudgets(on: category).filter { budget in
                let budgetDate = budget.date.asString(withDateFormat: .monthYear)
                let currentDate = date.asString(withDateFormat: .monthYear)
                return budgetDate == currentDate
            }.first
        }
    }
    
    public func removeBudget(id: UUID) throws {
        try database.viewContext.performAndWait {
            guard let model = getBudget(by: id) else { throw RefdsBudgetError.notFoundBudget }
            transactionRepository.getTransactions(from: model.date.date, format: .monthYear).map {
                $0.getEntity(for: self.database.viewContext)
            }.forEach { self.database.viewContext.delete($0) }
            let entity = model.getEntity(for: database.viewContext)
            database.viewContext.delete(entity)
            try database.viewContext.save()
        }
    }
    
    public func addBudget(
        id: UUID,
        amount: Double,
        date: Date,
        message: String?,
        category: UUID
    ) throws {
        try database.viewContext.performAndWait {
            guard let model = getBudget(by: id) else {
                let entity = BudgetEntity(context: self.database.viewContext)
                entity.id = id
                entity.amount = amount
                entity.date = date.timestamp
                entity.message = message
                entity.category = category
                try self.database.viewContext.save()
                return
            }
            let entity = model.getEntity(for: self.database.viewContext)
            entity.id = id
            entity.amount = amount
            entity.date = date.timestamp
            entity.message = message
            entity.category = category
            try self.database.viewContext.save()
        }
    }
}
