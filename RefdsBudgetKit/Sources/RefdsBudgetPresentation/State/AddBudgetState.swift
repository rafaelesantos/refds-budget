import Foundation
import RefdsRedux
import RefdsShared
import RefdsBudgetDomain

public protocol AddBudgetStateProtocol: RefdsReduxState {
    var id: UUID { get set }
    var categoryName: String? { get set }
    var amount: Double { get set }
    var description: String { get set }
    var date: Date { get set }
    var category: CategoryRowViewDataProtocol? { get set }
    var categories: [CategoryRowViewDataProtocol] { get set }
    var canSave: Bool { get }
    var isLoading: Bool { get set }
    var hasAISuggestion: Bool { get set }
    var error: RefdsBudgetError? { get set }
}

public struct AddBudgetState: AddBudgetStateProtocol {
    public var id: UUID
    public var categoryName: String?
    public var amount: Double
    public var description: String
    public var date: Date
    public var category: CategoryRowViewDataProtocol?
    public var categories: [CategoryRowViewDataProtocol]
    public var isLoading: Bool
    public var hasAISuggestion: Bool
    public var error: RefdsBudgetError?
    
    public var canSave: Bool {
        amount != .zero && 
        category != nil &&
        description.isEmpty == false
    }
    
    public init(
        id: UUID = .init(),
        categoryName: String? = nil,
        amount: Double = .zero,
        description: String = "",
        date: Date = .now,
        category: CategoryRowViewDataProtocol? = nil,
        categories: [CategoryRowViewDataProtocol] = [],
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
