import Foundation
import SwiftUI
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class LocalTransactionRepositoryMock: TransactionUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getTransactions() -> [TransactionEntity] {
        (1 ... 20).map { _ in TransactionEntityMock.value(for: database.viewContext) }
    }
    
    public func getTransaction(by id: UUID) -> TransactionEntity? {
        TransactionEntityMock.value(for: database.viewContext)
    }
    
    public func getTransactions(on category: UUID) -> [TransactionEntity] {
        (1 ... 20).map { _ in TransactionEntityMock.value(for: database.viewContext) }
    }
    
    public func getTransactions(from date: Date, format: String.DateFormat) -> [TransactionEntity] {
        (1 ... 20).map { _ in TransactionEntityMock.value(for: database.viewContext) }
    }
    
    public func getTransactions(on category: UUID, from date: Date, format: String.DateFormat) -> [TransactionEntity] {
        (1 ... 20).map { _ in TransactionEntityMock.value(for: database.viewContext) }
    }
    
    public func removeTransaction(by id: UUID) throws {}
    
    public func removeTransactions(by ids: [UUID]) throws {}
    
    public func addTransaction(
        id: UUID,
        date: Date,
        message: String,
        category: UUID,
        amount: Double,
        status: TransactionStatus
    ) throws {}
}
