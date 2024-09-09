import Foundation
import SwiftUI
import RefdsShared

public struct CategoryRowViewDataMock: CategoryRowViewDataProtocol {
    public var id: UUID = .init()
    public var icon: String = RefdsIconSymbol.random.rawValue
    public var name: String = .someWord()
    public var description: String? = .someParagraph()
    public var color: Color = .random
    public var budget: Double = .random(in: 250 ... 2000)
    public var percentage: Double = .random(in: 0.1 ... 0.9)
    public var transactionsAmount: Int = .random(in: 2 ... 30)
    public var spend: Double = .random(in: 300 ... 1980)
    public var isAnimate: Bool = false
    
    public init() {}
}
