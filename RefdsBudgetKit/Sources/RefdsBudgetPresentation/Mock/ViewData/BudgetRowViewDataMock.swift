import Foundation
import SwiftUI

public struct BudgetRowViewDataMock: BudgetRowViewDataProtocol {
    public var id: UUID = .init()
    public var date: Date = .random
    public var description: String? = .someParagraph()
    public var amount: Double = .random(in: 100 ... 1000)
    public var spend: Double = .random(in: 100 ... 1000)
    public var percentage: Double = .random(in: 0.2 ... 0.8)
    public var isSelected: Bool = false
    public var hasAI: Bool = false
    
    public init() {}
}
