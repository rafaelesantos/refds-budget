import Foundation
import SwiftUI
import RefdsShared

public struct TransactionRowViewDataMock: TransactionRowViewDataProtocol {
    public var id: UUID = .init()
    public var icon: String = RefdsIconSymbol.random.rawValue
    public var color: Color = .random
    public var amount: Double = .random(in: 10 ... 700)
    public var description: String = .someParagraph()
    public var date: Date = .random

    public init() {}
}
