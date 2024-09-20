import Foundation
import CoreData
import Domain

public struct BudgetModelMock: BudgetModelProtocol {
    public var amount: Double = .random(in: 100 ... 1000)
    public var category: UUID = .init()
    public var date: TimeInterval = Date.current.timeIntervalSince1970
    public var id: UUID = .init()
    public var message: String? = .someParagraph()
    
    public init() {}
    
    public func getEntity(for context: NSManagedObjectContext) -> BudgetEntity {
        BudgetEntity(model: self, for: context)
    }
}
