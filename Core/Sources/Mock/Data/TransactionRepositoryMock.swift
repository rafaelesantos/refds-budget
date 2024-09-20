import Foundation
import RefdsInjection
import RefdsShared
import Domain

public final class TransactionRepositoryMock: TransactionUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getAllTransactions() -> [TransactionModelProtocol] {
        (1 ... 1_000).map { _ in TransactionModelMock() }
    }
    
    public func getTransactions(on category: UUID) -> [TransactionModelProtocol] {
        getAllTransactions()
    }
    
    public func getTransactions(
        from date: Date,
        format: String.DateFormat
    ) -> [TransactionModelProtocol] {
        getAllTransactions()
    }
    
    public func getTransactions(
        on category: UUID,
        from date: Date,
        format: String.DateFormat
    ) -> [TransactionModelProtocol] {
        getAllTransactions()
    }
    
    public func getTransaction(by id: UUID) -> TransactionModelProtocol? {
        TransactionModelMock()
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
