import SwiftUI
import Domain

struct BudgetItemViewData: BudgetItemViewDataProtocol {
    var id: UUID
    var date: Date
    var description: String?
    var amount: Double
    var spend: Double
    var percentage: Double
    var isSelected: Bool = false
    var hasAI: Bool = false
    
    init(
        id: UUID,
        date: Date,
        description: String? = nil,
        amount: Double,
        spend: Double,
        percentage: Double,
        isSelected: Bool = false,
        hasAI: Bool = false
    ) {
        self.id = id
        self.date = date
        self.description = description
        self.amount = amount
        self.spend = spend
        self.percentage = percentage
        self.isSelected = isSelected
        self.hasAI = hasAI
    }
}
