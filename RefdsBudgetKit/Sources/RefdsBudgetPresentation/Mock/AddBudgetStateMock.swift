import Foundation
import RefdsBudgetData

public struct AddBudgetStateMock: BudgetStateProtocol {
    public var id: UUID = .init()
    public var amount: Double = .random(in: 250 ... 750)
    public var description: String? = .someParagraph()
    public var month: Date = .current
    public var categoryId: UUID = .init()
    public var error: RefdsBudgetError? = Bool.random() ? nil : .existingBudget
    
    public init() {}
}
