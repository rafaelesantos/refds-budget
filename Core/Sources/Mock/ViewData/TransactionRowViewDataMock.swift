import SwiftUI
import RefdsShared
import Domain

public struct TransactionItemViewDataMock: TransactionItemViewDataProtocol {
    public var id: UUID = .init()
    public var icon: String = RefdsIconSymbol.random.rawValue
    public var color: Color = .random
    public var amount: Double = .random(in: 10 ... 700)
    public var description: String = .someParagraph()
    public var date: Date = .random
    public var status: TransactionStatus = .pending

    public init() {}
}
