import SwiftUI
import RefdsShared

public protocol TagItemViewDataProtocol {
    var id: UUID { get set }
    var name: String { get set }
    var color: Color { get set }
    var icon: RefdsIconSymbol { get set }
    var value: Double? { get set }
    var amount: Int? { get set }
    var isAnimate: Bool { get set }
}
