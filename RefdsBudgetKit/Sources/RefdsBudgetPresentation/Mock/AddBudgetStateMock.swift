import Foundation
import RefdsBudgetData

public struct AddBudgetStateMock: BudgetStateProtocol {
    public var id: UUID = .init()
    public var amount: Double = 525.92
    public var description: String = .someParagraph()
    public var month: Date = .current
    public var category: CategoryStateProtocol? = nil
    public var categories: [CategoryStateProtocol] = []
    public var error: RefdsBudgetError? = Bool.random() ? nil : .existingBudget
    
    public var canSave: Bool {
        amount != .zero && category != nil
    }
    
    public init() {}
}
