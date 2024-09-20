import Foundation
import Domain
import Resource

public struct WidgetExpensesViewData: WidgetExpensesViewDataProtocol {
    public var isFilterByDate: Bool
    public var category: String
    public var tag: String
    public var status: String
    public var date: Date
    public var spend: Double
    public var budget: Double
    
    public var percent: Double {
        spend / (budget == .zero ? 1 : budget)
    }
    
    public var remaining: Double {
        budget - spend
    }
    
    public init(
        isFilterByDate: Bool = true,
        category: String = .localizable(by: .transactionsCategoriesAllSelected),
        tag: String = .localizable(by: .transactionsCategoriesAllSelected),
        status: String = .localizable(by: .transactionsCategoriesAllSelected),
        date: Date = .now,
        spend: Double = .zero,
        budget: Double = .zero
    ) {
        self.isFilterByDate = isFilterByDate
        self.category = category
        self.tag = tag
        self.status = status
        self.date = date
        self.spend = spend
        self.budget = budget
    }
}
