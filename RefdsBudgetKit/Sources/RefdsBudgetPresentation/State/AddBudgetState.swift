import Foundation
import RefdsRedux
import RefdsShared
import RefdsBudgetData

public protocol AddBudgetStateProtocol: RefdsReduxState {
    var id: UUID { get set }
    var amount: Double { get set }
    var description: String { get set }
    var month: Date { get set }
    var category: AddCategoryStateProtocol? { get set }
    var categories: [AddCategoryStateProtocol] { get set }
    var canSave: Bool { get }
    var error: RefdsBudgetError? { get set }
}

public struct AddBudgetState: AddBudgetStateProtocol {
    public var id: UUID
    public var amount: Double
    public var description: String
    public var month: Date
    public var category: AddCategoryStateProtocol?
    public var categories: [AddCategoryStateProtocol]
    public var error: RefdsBudgetError?
    
    public var canSave: Bool {
        amount != .zero && category != nil
    }
    
    public init(
        id: UUID = .init(),
        amount: Double = .zero,
        description: String = "",
        month: Date = .current,
        category: AddCategoryStateProtocol? = nil,
        categories: [AddCategoryStateProtocol] = [],
        error: RefdsBudgetError? = nil
    ) {
        self.id = id
        self.amount = amount
        self.description = description
        self.month = month
        self.category = category
        self.categories = categories
        self.error = error
    }
}
