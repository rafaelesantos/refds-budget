import Foundation
import RefdsRedux
import RefdsShared
import RefdsBudgetDomain
import RefdsBudgetData

public protocol AddTransactionStateProtocol: RefdsReduxState {
    var id: UUID { get set }
    var amount: Double { get set }
    var description: String { get set }
    var status: TransactionStatus { get set }
    var category: CategoryRowViewDataProtocol? { get set }
    var categories: [CategoryRowViewDataProtocol] { get set }
    var tags: [TagRowViewDataProtocol] { get set }
    var remaining: Double? { get set }
    var date: Date { get set }
    var isEmptyBudgets: Bool { get }
    var isLoading: Bool { get set }
    var hasAI: Bool { get set }
    var error: RefdsBudgetError? { get set }
}

public struct AddTransactionState: AddTransactionStateProtocol {
    public var id: UUID
    public var amount: Double
    public var description: String
    public var status: TransactionStatus
    public var category: CategoryRowViewDataProtocol?
    public var categories: [CategoryRowViewDataProtocol]
    public var tags: [TagRowViewDataProtocol]
    public var remaining: Double?
    public var date: Date
    public var error: RefdsBudgetError?
    public var isLoading: Bool
    public var hasAI: Bool
    
    public var isEmptyBudgets: Bool {
        categories.isEmpty
    }
    
    public init(
        id: UUID = .init(),
        amount: Double = .zero,
        description: String = "",
        status: TransactionStatus = .spend,
        category: CategoryRowViewDataProtocol? = nil,
        categories: [CategoryRowViewDataProtocol] = [],
        tags: [TagRowViewDataProtocol] = [],
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
