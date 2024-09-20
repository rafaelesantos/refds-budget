import Foundation
import Domain

struct AddBudgetState: AddBudgetStateProtocol {
    var id: UUID
    var categoryName: String?
    var amount: Double
    var description: String
    var date: Date
    var category: CategoryItemViewDataProtocol?
    var categories: [CategoryItemViewDataProtocol]
    var isLoading: Bool
    var hasAISuggestion: Bool
    var error: RefdsBudgetError?
    
    var canSave: Bool {
        amount != .zero && 
        category != nil &&
        description.isEmpty == false
    }
    
    init(
        id: UUID = .init(),
        categoryName: String? = nil,
        amount: Double = .zero,
        description: String = "",
        date: Date = .now,
        category: CategoryItemViewDataProtocol? = nil,
        categories: [CategoryItemViewDataProtocol] = [],
        isLoading: Bool = true,
        hasAISuggestion: Bool = false,
        error: RefdsBudgetError? = nil
    ) {
        self.id = id
        self.categoryName = categoryName
        self.amount = amount
        self.description = description
        self.date = date
        self.category = category
        self.categories = categories
        self.isLoading = isLoading
        self.hasAISuggestion = hasAISuggestion
        self.error = error
    }
}
