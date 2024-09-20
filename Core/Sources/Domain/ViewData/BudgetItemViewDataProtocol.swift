import SwiftUI

public protocol BudgetItemViewDataProtocol {
    var id: UUID { get }
    var date: Date { get }
    var description: String? { get }
    var amount: Double { get set }
    var spend: Double { get set }
    var percentage: Double { get set }
    var isSelected: Bool { get set }
    var hasAI: Bool { get set }
}
