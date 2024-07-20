import Foundation
import RefdsShared
import CoreData

public struct TransactionModelMock: TransactionModelProtocol {
    public var amount: Double = .random(in: 10 ... 300)
    public var category: UUID = .init()
    public var date: TimeInterval = Date.current.timeIntervalSince1970
    public var id: UUID = .init()
    public var message: String = .someParagraph()
    public var status: String = TransactionStatus.spend.rawValue
    
    public init() {}
    
    public func getEntity(for context: NSManagedObjectContext) -> TransactionEntity {
        TransactionEntity(model: self, for: context)
    }
}
