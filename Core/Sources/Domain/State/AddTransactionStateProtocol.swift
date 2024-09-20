import Foundation
import RefdsRedux

public protocol AddTransactionStateProtocol: RefdsReduxState {
    var id: UUID { get set }
    var amount: Double { get set }
    var description: String { get set }
    var status: TransactionStatus { get set }
    var category: CategoryItemViewDataProtocol? { get set }
    var categories: [CategoryItemViewDataProtocol] { get set }
    var tags: [TagItemViewDataProtocol] { get set }
    var remaining: Double? { get set }
    var date: Date { get set }
    var isEmptyBudgets: Bool { get }
    var isLoading: Bool { get set }
    var hasAI: Bool { get set }
    var error: RefdsBudgetError? { get set }
}
