import Foundation
import RefdsRedux

public protocol BalanceRowViewDataProtocol: RefdsReduxState {
    var title: String? { get set }
    var subtitle: String? { get set }
    var expense: Double { get set }
    var income: Double { get set }
    var budget: Double { get set }
    var spendPercentage: Double { get }
    var amount: Int { get set }
}

public struct BalanceRowViewData: BalanceRowViewDataProtocol {
    public var title: String?
    public var subtitle: String?
    public var expense: Double
    public var income: Double
    public var budget: Double
    public var amount: Int
    
    public var spendPercentage: Double {
        expense / (budget == 0 ? 1 : budget)
    }
    
    public init(
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
