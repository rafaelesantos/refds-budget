import SwiftUI
import RefdsShared
import Domain

public struct TagItemViewData: TagItemViewDataProtocol {
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
