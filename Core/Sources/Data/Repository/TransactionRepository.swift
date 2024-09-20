import Foundation
import RefdsInjection
import RefdsShared
import Domain

public final class TransactionRepository: TransactionUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getAllTransactions() -> [TransactionModelProtocol] {
        database.viewContext.performAndWait {
            let request = TransactionEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            guard let entities = try? database.viewContext.fetch(request) else { return [] }
            return entities.map { TransactionModel(entity: $0) }
        }
    }
    
    public func getTransactions(on category: UUID) -> [TransactionModelProtocol] {
        database.viewContext.performAndWait {
            let request = TransactionEntity.fetchRequest()
            request.predicate = NSPredicate(format: "category = %@", category as CVarArg)
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            guard let entities = try? database.viewContext.fetch(request) else { return [] }
            return entities.map { TransactionModel(entity: $0) }
        }
    }
    
    public func getTransactions(
        from date: Date,
        format: String.DateFormat
    ) -> [TransactionModelProtocol] {
        database.viewContext.performAndWait {
            return getAllTransactions().filter { transaction in
                let transactionDate = transaction.date.asString(withDateFormat: format)
                let currentDate = date.asString(withDateFormat: format)
                return transactionDate == currentDate
            }
        }
    }
    
    public func getTransactions(
        on category: UUID,
        from date: Date,
        format: String.DateFormat
    ) -> [TransactionModelProtocol] {
        database.viewContext.performAndWait {
            return getTransactions(on: category).filter { transaction in
                let transactionDate = transaction.date.asString(withDateFormat: format)
                let currentDate = date.asString(withDateFormat: format)
                return transactionDate == currentDate
            }
        }
    }
    
    public func getTransaction(by id: UUID) -> TransactionModelProtocol? {
        database.viewContext.performAndWait {
            let request = TransactionEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            guard let entity = try? database.viewContext.fetch(request).first else { return nil }
            return TransactionModel(entity: entity)
        }
    }
    
    public func removeTransaction(by id: UUID) throws {
        try database.viewContext.performAndWait {
            guard let model = getTransaction(by: id) else { throw RefdsBudgetError.notFoundTransaction }
            let entity = model.getEntity(for: self.database.viewContext)
            self.database.viewContext.delete(entity)
            try self.database.viewContext.save()
        }
    }
    
    public func removeTransactions(by ids: [UUID]) throws {
        try database.viewContext.performAndWait {
            let transactions = getAllTransactions().filter { ids.contains($0.id) }
            if !transactions.isEmpty {
                transactions.map {
                    $0.getEntity(for: self.database.viewContext)
                }.forEach { self.database.viewContext.delete($0) }
                try self.database.viewContext.save()
            }
        }
    }
    
    public func addTransaction(
        id: UUID,
        date: Date,
        message: String,
        category: UUID,
        amount: Double,
        status: TransactionStatus
    ) throws {
        try database.viewContext.performAndWait {
            guard let model = getTransaction(by: id) else {
                let entity = TransactionEntity(context: self.database.viewContext)
                entity.id = id
                entity.date = date.timestamp
                entity.message = message
                entity.category = category
                entity.amount = amount
                entity.status = status.rawValue
                try self.database.viewContext.save()
                return
            }
            let entity = model.getEntity(for: self.database.viewContext)
            entity.id = id
            entity.date = date.timestamp
            entity.message = message
            entity.category = category
            entity.amount = amount
            entity.status = status.rawValue
            try self.database.viewContext.save()
        }
    }
}
