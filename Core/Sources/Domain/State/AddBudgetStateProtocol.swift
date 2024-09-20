import Foundation
import RefdsRedux

public protocol AddBudgetStateProtocol: RefdsReduxState {
    var id: UUID { get set }
    var categoryName: String? { get set }
    var amount: Double { get set }
    var description: String { get set }
    var date: Date { get set }
    var category: CategoryItemViewDataProtocol? { get set }
    var categories: [CategoryItemViewDataProtocol] { get set }
    var canSave: Bool { get }
    var isLoading: Bool { get set }
    var hasAISuggestion: Bool { get set }
    var error: RefdsBudgetError? { get set }
}
