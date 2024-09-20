import Foundation
import RefdsRedux
import Domain

struct AddTransactionState: AddTransactionStateProtocol {
    var id: UUID
    var amount: Double
    var description: String
    var status: TransactionStatus
    var category: CategoryItemViewDataProtocol?
    var categories: [CategoryItemViewDataProtocol]
    var tags: [TagItemViewDataProtocol]
    var remaining: Double?
    var date: Date
    var error: RefdsBudgetError?
    var isLoading: Bool
    var hasAI: Bool
    
    var isEmptyBudgets: Bool {
        categories.isEmpty
    }
    
    init(
        id: UUID = .init(),
        amount: Double = .zero,
        description: String = "",
        status: TransactionStatus = .spend,
        category: CategoryItemViewDataProtocol? = nil,
        categories: [CategoryItemViewDataProtocol] = [],
        tags: [TagItemViewDataProtocol] = [],
        remaining: Double? = nil,
        date: Date = .current,
        error: RefdsBudgetError? = nil
    ) {
        self.id = id
        self.amount = amount
        self.description = description
        self.status = status
        self.category = category
        self.categories = categories
        self.tags = tags
        self.remaining = remaining
        self.date = date
        self.error = error
        self.isLoading = category == nil
        self.hasAI = category == nil
    }
}
