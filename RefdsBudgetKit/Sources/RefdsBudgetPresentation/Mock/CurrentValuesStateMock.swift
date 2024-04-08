import Foundation

public struct CurrentValuesStateMock: CurrentValuesStateProtocol {
    public var expense: Double = .random(in: 250 ... 750)
    public var income: Double = .random(in: 250 ... 750)
    public var budget: Double = .random(in: 250 ... 750)
    
    public init() {}
}
