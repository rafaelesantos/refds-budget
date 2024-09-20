import Foundation
import Domain

public struct BalanceViewDataMock: BalanceViewDataProtocol {
    public var title: String? = .someWord()
    public var subtitle: String? = .someWord()
    public var expense: Double = .random(in: 250 ... 750)
    public var income: Double = .random(in: 250 ... 750)
    public var budget: Double = .random(in: 250 ... 750)
    public var amount: Int = .random(in: 25 ... 75)
    
    public var spendPercentage: Double {
        expense / (budget == 0 ? 1 : budget)
    }
    
    public init() {}
}
