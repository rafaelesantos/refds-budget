import Foundation
import RefdsRedux

public protocol BalanceViewDataProtocol: RefdsReduxState {
    var title: String? { get set }
    var subtitle: String? { get set }
    var expense: Double { get set }
    var income: Double { get set }
    var budget: Double { get set }
    var spendPercentage: Double { get }
    var amount: Int { get set }
}
