import Foundation

public struct SystemSmallExpenseTrackerViewDataMock: SystemSmallExpenseTrackerViewDataProtocol {
    public var isFilterByDate: Bool = true
    public var date: Date = .random
    public var spend: Double = .random(in: 250 ... 2500)
    public var budget: Double = .random(in: 2000 ... 3000)
    
    public var percent: Double {
        spend / (budget == .zero ? 1 : budget)
    }
    
    public var remaining: Double {
        budget - spend
    }
    
    public init() {}
}
