import SwiftUI

public protocol CategoryItemViewDataProtocol {
    var id: UUID { get }
    var icon: String { get }
    var name: String { get }
    var description: String? { get }
    var color: Color { get }
    var budget: Double { get }
    var percentage: Double { get }
    var transactionsAmount: Int { get }
    var spend: Double { get }
    var isAnimate: Bool { get set }
}
