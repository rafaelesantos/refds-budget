import Foundation

public protocol WidgetExpenseTrackerViewDataProtocol {
    var isFilterByDate: Bool { get set }
    var category: String { get set }
    var tag: String { get set }
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
        isFilterByDate: Bool,
        category: String,
        tag: String,
        date: Date,
        spend: Double,
        budget: Double
    ) {
        self.isFilterByDate = isFilterByDate
        self.category = category
        self.tag = tag
        self.date = date
        self.spend = spend
        self.budget = budget
    }
}
