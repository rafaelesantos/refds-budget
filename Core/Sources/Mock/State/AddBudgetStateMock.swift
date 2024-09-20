import Foundation
import Domain

public struct AddBudgetStateMock: AddBudgetStateProtocol {
    public var id: UUID = .init()
    public var categoryName: String? = nil
    public var amount: Double = 525.92
    public var description: String = .someParagraph()
    public var date: Date = .current
    public var category: CategoryItemViewDataProtocol? = nil
    public var categories: [CategoryItemViewDataProtocol] = []
    public var isLoading: Bool = true
    public var hasAISuggestion: Bool = true
    public var error: RefdsBudgetError? = Bool.random() ? nil : .existingBudget
    
    public var canSave: Bool {
        amount != .zero && category != nil
    }
    
    public init() {}
}
