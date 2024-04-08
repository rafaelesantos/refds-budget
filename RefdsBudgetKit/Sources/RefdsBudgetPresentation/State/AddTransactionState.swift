import Foundation
import RefdsRedux
import RefdsShared
import RefdsBudgetData

public protocol TransactionStateProtocol: RefdsReduxState {
    var id: UUID { get set }
    var amount: Double { get set }
    var description: String { get set }
    var category: CategoryStateProtocol? { get set }
    var categories: [CategoryStateProtocol] { get set }
    var remaining: Double? { get set }
    var date: Date { get set }
    var error: RefdsBudgetError? { get set }
}

public struct AddTransactionState: TransactionStateProtocol {
    public var id: UUID
    public var amount: Double
    public var description: String
    public var category: CategoryStateProtocol?
    public var categories: [CategoryStateProtocol]
    public var remaining: Double?
    public var date: Date
    public var error: RefdsBudgetError?
    
    public init(
        id: UUID = .init(),
        amount: Double = .zero,
        description: String = "",
        category: CategoryStateProtocol? = nil,
        categories: [CategoryStateProtocol] = [],
        remaining: Double? = nil,
        date: Date = .current,
        error: RefdsBudgetError? = nil
    ) {
        self.id = id
        self.amount = amount
        self.description = description
        self.category = category
        self.categories = categories
        self.remaining = remaining
        self.date = date
        self.error = error
    }
}
