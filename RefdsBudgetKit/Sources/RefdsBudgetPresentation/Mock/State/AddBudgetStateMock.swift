import Foundation
import RefdsBudgetData

public struct AddBudgetStateMock: AddBudgetStateProtocol {
    public var id: UUID = .init()
    public var amount: Double = 525.92
    public var description: String = .someParagraph()
    public var month: Date = .current
    public var category: AddCategoryStateProtocol? = nil
    public var categories: [AddCategoryStateProtocol] = []
    public var isLoading: Bool = true
    public var isAI: Bool = true
    public var error: RefdsBudgetError? = Bool.random() ? nil : .existingBudget
    
    public var canSave: Bool {
        amount != .zero && category != nil
    }
    
    public init() {}
}
