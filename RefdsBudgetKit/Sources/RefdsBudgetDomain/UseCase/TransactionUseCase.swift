import Foundation
import RefdsShared

public protocol TransactionUseCase {
    func getTransactions() -> [TransactionEntity]
    func getTransaction(by id: UUID) -> TransactionEntity?
    func getTransactions(on category: UUID) -> [TransactionEntity]
    
    func getTransactions(
        from date: Date,
        format: String.DateFormat
    ) -> [TransactionEntity]
    
    func getTransactions(
        on category: UUID,
        from date: Date,
        format: String.DateFormat
    ) -> [TransactionEntity]
    
    func removeTransaction(by id: UUID) throws
    
    func addTransaction(
        id: UUID,
        date: Date,
        message: String,
        category: UUID,
        amount: Double,
        status: TransactionStatus
    ) throws
}
