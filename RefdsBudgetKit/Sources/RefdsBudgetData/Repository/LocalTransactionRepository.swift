import Foundation
import SwiftUI
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class LocalTransactionRepository: TransactionUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getTransactions() -> [TransactionEntity] {
        let request = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return (try? database.viewContext.fetch(request)) ?? []
    }
    
    public func getTransaction(by id: UUID) -> TransactionEntity? {
        let request = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        guard let transaction = try? database.viewContext.fetch(request).first else { return nil }
        return transaction
    }
    
    public func getTransactions(on category: UUID) -> [TransactionEntity] {
        let request = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@", category as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        guard let transactions = try? database.viewContext.fetch(request) else { return [] }
        return transactions
    }
    
    public func getTransactions(from date: Date, format: String.DateFormat) -> [TransactionEntity] {
        getTransactions().filter { transaction in
            let transactionDate = transaction.date.asString(withDateFormat: format)
            let currentDate = date.asString(withDateFormat: format)
            return transactionDate == currentDate
        }
    }
    
    public func getTransactions(on category: UUID, from date: Date, format: String.DateFormat) -> [TransactionEntity] {
        getTransactions(on: category).filter { transaction in
            let transactionDate = transaction.date.asString(withDateFormat: format)
            let currentDate = date.asString(withDateFormat: format)
            return transactionDate == currentDate
        }
    }
    
    public func removeTransaction(by id: UUID) throws {
        guard let transaction = getTransaction(by: id) else { throw RefdsBudgetError.notFoundTransaction }
        database.viewContext.delete(transaction)
        try database.viewContext.save()
    }
    
    public func removeTransactions(by ids: [UUID]) throws {
        let transactions = getTransactions().filter { ids.contains($0.id) }
        if !transactions.isEmpty {
            transactions.forEach {
                database.viewContext.delete($0)
            }
            try database.viewContext.save()
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
        guard let transaction = getTransaction(by: id) else {
            let transaction = TransactionEntity(context: database.viewContext)
            transaction.id = id
            transaction.date = date.timestamp
            transaction.message = message
            transaction.category = category
            transaction.amount = amount
            transaction.status = status.rawValue
            try database.viewContext.save()
            return
        }
        transaction.id = id
        transaction.date = date.timestamp
        transaction.message = message
        transaction.category = category
        transaction.amount = amount
        transaction.status = status.rawValue
        try database.viewContext.save()
    }
}
