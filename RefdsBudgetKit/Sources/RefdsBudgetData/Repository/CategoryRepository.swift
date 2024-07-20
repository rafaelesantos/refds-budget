import Foundation
import SwiftUI
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class CategoryRepository: CategoryUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    @RefdsInjection private var budgetRepository: BudgetUseCase
    
    public init() {}
    
    public func getAllCategories() -> [CategoryModelProtocol] {
        let request = CategoryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let entities = try? database.viewContext.fetch(request) else { return [] }
        return entities.map { CategoryModel(entity: $0) }
        
//        try? database.viewContext.performAndWait {
//            if let entities = try? self.database.viewContext.fetch(CategoryEntity.fetchRequest()) {
//                for entity in entities {
//                    self.database.viewContext.delete(entity)
//                }
//                try self.database.viewContext.save()
//            }
//            
//            if let entities = try? self.database.viewContext.fetch(BudgetEntity.fetchRequest()) {
//                for entity in entities {
//                    self.database.viewContext.delete(entity)
//                }
//                try self.database.viewContext.save()
//            }
//            
//            if let entities = try? self.database.viewContext.fetch(TransactionEntity.fetchRequest()) {
//                for entity in entities {
//                    self.database.viewContext.delete(entity)
//                }
//                try self.database.viewContext.save()
//            }
//        }
//        return []
    }
    
    public func getCategories(from date: Date) -> [CategoryModelProtocol] {
        return getAllCategories().filter {
            budgetRepository.getBudget(on: $0.id, from: date) != nil
        }
    }
    
    public func getCategory(by id: UUID) -> CategoryModelProtocol? {
        let request = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        guard let entity = try? database.viewContext.fetch(request).first else { return nil }
        return CategoryModel(entity: entity)
    }
    
    public func removeCategory(id: UUID) throws {
        try database.viewContext.performAndWait {
            guard let model = getCategory(by: id) else { throw RefdsBudgetError.notFoundCategory }
            let entity = model.getEntity(for: self.database.viewContext)
            budgetRepository.getBudgets(on: model.id).map {
                $0.getEntity(for: self.database.viewContext)
            }.forEach { self.database.viewContext.delete($0) }
            self.database.viewContext.delete(entity)
            try self.database.viewContext.save()
        }
    }
    
    public func addCategory(
        id: UUID,
        name: String,
        color: Color,
        budgets: [UUID],
        icon: String
    ) throws {
        try database.viewContext.performAndWait {
            guard let model = getCategory(by: id) else {
                let entity = CategoryEntity(context: self.database.viewContext)
                entity.id = id
                entity.name = name.capitalized
                entity.color = color.asHex
                entity.budgets = budgets
                entity.icon = icon
                try self.database.viewContext.save()
                return
            }
            let entity = model.getEntity(for: self.database.viewContext)
            entity.id = id
            entity.name = name.capitalized
            entity.color = color.asHex
            entity.budgets = budgets
            entity.icon = icon
            try self.database.viewContext.save()
        }
    }
}
