import Foundation
import RefdsBudgetResource

public protocol WidgetExpenseTrackerViewDataProtocol {
    var isFilterByDate: Bool { get set }
    var category: String { get set }
    var tag: String { get set }
    var status: String { get set }
    var date: Date { get set }
    var spend: Double { get set }
    var budget: Double { get set }
    var percent: Double { get }
    var remaining: Double { get }
}

public struct WidgetExpenseTrackerViewData: WidgetExpenseTrackerViewDataProtocol {
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
        category: String = .localizable(by: .transactionsCategorieAllSelected),
        tag: String = .localizable(by: .transactionsCategorieAllSelected),
        status: String = .localizable(by: .transactionsCategorieAllSelected),
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
