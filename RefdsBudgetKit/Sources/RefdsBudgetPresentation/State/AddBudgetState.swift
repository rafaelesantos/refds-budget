import Foundation
import RefdsRedux
import RefdsShared
import RefdsBudgetData

public protocol AddBudgetStateProtocol: RefdsReduxState {
    var id: UUID { get set }
    var amount: Double { get set }
    var description: String? { get set }
    var month: Date { get set }
    var categoryId: UUID { get set }
    var error: RefdsBudgetError? { get set }
}

public struct AddBudgetState: AddBudgetStateProtocol {
    public var id: UUID
    public var amount: Double
    public var description: String?
    public var month: Date
    public var categoryId: UUID
    public var error: RefdsBudgetError?
    
    public init(
        id: UUID = .init(),
        amount: Double = 0,
        description: String? = nil,
        month: Date = .current,
        categoryId: UUID
    ) {
        self.id = id
        self.amount = amount
        self.description = description
        self.month = month
        self.categoryId = categoryId
    }
}
