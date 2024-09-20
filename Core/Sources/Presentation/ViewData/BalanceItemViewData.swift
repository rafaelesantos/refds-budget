import Foundation
import Domain

struct BalanceViewData: BalanceViewDataProtocol {
    var title: String?
    var subtitle: String?
    var expense: Double
    var income: Double
    var budget: Double
    var amount: Int
    
    var spendPercentage: Double {
        expense / (budget == 0 ? 1 : budget)
    }
    
    init(
        title: String? = nil,
        subtitle: String? = nil,
        expense: Double = .zero,
        income: Double = .zero,
        budget: Double = .zero,
        amount: Int = .zero
    ) {
        self.title = title
        self.subtitle = subtitle
        self.expense = expense
        self.income = income
        self.budget = budget
        self.amount = amount
    }
}
