import SwiftUI
import RefdsShared

public protocol FilterItemViewDataProtocol {
    var id: String { get }
    var name: String { get }
    var color: Color { get }
    var icon: RefdsIconSymbol? { get }
}
