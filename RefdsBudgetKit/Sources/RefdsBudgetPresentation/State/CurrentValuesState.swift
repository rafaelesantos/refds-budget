import Foundation
import RefdsRedux

public protocol CurrentValuesStateProtocol: RefdsReduxState {
    var expense: Double { get set }
    var income: Double { get set }
    var budget: Double { get set }
}

public struct CurrentValuesState: CurrentValuesStateProtocol {
    public var expense: Double
    public var income: Double
    public var budget: Double
    
    public init(
        expense: Double,
        income: Double,
        budget: Double
    ) {
        self.expense = expense
        self.income = income
        self.budget = budget
    }
}
