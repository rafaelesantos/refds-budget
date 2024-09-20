import Foundation
import RefdsShared

public protocol TransactionUseCase {
    func getAllTransactions() -> [TransactionModelProtocol]
    func getTransactions(on category: UUID) -> [TransactionModelProtocol]
    func getTransactions(
        from date: Date,
        format: String.DateFormat
    ) -> [TransactionModelProtocol]
    func getTransactions(
        on category: UUID,
        from date: Date,
        format: String.DateFormat
    ) -> [TransactionModelProtocol]
    
    func getTransaction(by id: UUID) -> TransactionModelProtocol?
    
    func removeTransaction(by id: UUID) throws
    func removeTransactions(by ids: [UUID]) throws
    
    func addTransaction(
        id: UUID,
        date: Date,
        message: String,
        category: UUID,
        amount: Double,
        status: TransactionStatus
    ) throws
}
