import SwiftUI
import RefdsShared

public protocol TagRowViewDataProtocol {
    var id: UUID { get set }
    var name: String { get set }
    var color: Color { get set }
    var icon: RefdsIconSymbol { get set }
    var value: Double? { get set }
    var amount: Int? { get set }
    var isAnimate: Bool { get set }
}

public struct TagRowViewData: TagRowViewDataProtocol {
    public var id: UUID
    public var name: String
    public var color: Color
    public var icon: RefdsIconSymbol
    public var value: Double?
    public var amount: Int?
    public var isAnimate: Bool = false
    
    public init(
        id: UUID = .init(),
        name: String = "",
        color: Color = .random,
        icon: String = RefdsIconSymbol.dollarsign.rawValue,
        value: Double? = nil,
        amount: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.value = value
        self.amount = amount
        self.icon = RefdsIconSymbol(rawValue: icon) ?? .dollarsign
    }
}
