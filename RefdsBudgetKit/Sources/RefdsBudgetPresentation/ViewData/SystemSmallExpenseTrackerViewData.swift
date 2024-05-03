import Foundation

public protocol SystemSmallExpenseTrackerViewDataProtocol {
    var isFilterByDate: Bool { get set }
    var date: Date { get set }
    var spend: Double { get set }
    var budget: Double { get set }
    var percent: Double { get }
    var remaining: Double { get }
}

public struct SystemSmallExpenseTrackerViewData: SystemSmallExpenseTrackerViewDataProtocol {
    public var isFilterByDate: Bool
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
        date: Date,
        spend: Double,
        budget: Double
    ) {
        self.isFilterByDate = isFilterByDate
        self.date = date
        self.spend = spend
        self.budget = budget
    }
}
