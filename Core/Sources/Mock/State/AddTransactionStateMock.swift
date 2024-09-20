import Foundation
import Domain

public struct AddTransactionStateMock: AddTransactionStateProtocol {
    public var id: UUID = .init()
    public var amount: Double = .random(in: 250 ... 750)
    public var description: String = .someParagraph()
    public var status: TransactionStatus = .spend
    public var category: CategoryItemViewDataProtocol? = CategoryItemViewDataMock()
    public var categories: [CategoryItemViewDataProtocol] = (1 ... 4).map { _ in CategoryItemViewDataMock() }
    public var tags: [TagItemViewDataProtocol] = (1 ... 4).map { _ in TagItemViewDataMock() }
    public var remaining: Double? = .random(in: 25 ... 750)
    public var date: Date = .current
    public var error: RefdsBudgetError? = Bool.random() ? nil : .existingTransaction
    public var isEmptyCategories: Bool = false
    public var isEmptyBudgets: Bool = false
    public var isLoading: Bool = false
    public var hasAI: Bool = true
    
    public init() {}
}
