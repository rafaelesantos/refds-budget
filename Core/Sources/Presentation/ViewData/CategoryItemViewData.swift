import SwiftUI
import Domain

struct CategoryItemViewData: CategoryItemViewDataProtocol {
    var id: UUID
    var icon: String
    var name: String
    var description: String?
    var color: Color
    var budget: Double
    var percentage: Double
    var transactionsAmount: Int
    var spend: Double
    var isAnimate: Bool = false
    
    init(
        id: UUID,
        icon: String,
        name: String,
        description: String? = nil,
        color: Color,
        budget: Double = .zero,
        percentage: Double = .zero,
        transactionsAmount: Int = .zero,
        spend: Double = .zero
    ) {
        self.id = id
        self.icon = icon
        self.name = name
        self.description = description
        self.color = color
        self.budget = budget
        self.percentage = percentage
        self.transactionsAmount = transactionsAmount
        self.spend = spend
    }
}
