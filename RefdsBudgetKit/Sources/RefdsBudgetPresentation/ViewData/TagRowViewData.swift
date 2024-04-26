import SwiftUI
import RefdsShared

public protocol TagRowViewDataProtocol {
    var id: UUID { get set }
    var name: String { get set }
    var color: Color { get set }
    var value: Double? { get set }
    var amount: Int? { get set }
}

public struct TagRowViewData: TagRowViewDataProtocol {
    public var id: UUID
    public var name: String
    public var color: Color
    public var value: Double?
    public var amount: Int?
    
    public init(
        id: UUID = .init(),
        name: String = "",
        color: Color = .random,
        value: Double? = nil,
        amount: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.value = value
        self.amount = amount
    }
}
