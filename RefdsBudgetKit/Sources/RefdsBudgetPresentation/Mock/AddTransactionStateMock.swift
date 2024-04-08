import Foundation
import RefdsBudgetData

public struct AddTransactionStateMock: TransactionStateProtocol {
    public var id: UUID = .init()
    public var amount: Double = .random(in: 250 ... 750)
    public var description: String = .someParagraph()
    public var category: CategoryStateProtocol? = AddCategoryStateMock()
    public var categories: [CategoryStateProtocol] = (1 ... 4).map { _ in AddCategoryStateMock() }
    public var remaining: Double? = .random(in: 25 ... 750)
    public var date: Date = .current
    public var error: RefdsBudgetError? = Bool.random() ? nil : .existingTransaction
    
    public init() {}
}
