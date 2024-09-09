import SwiftUI
import RefdsShared
import RefdsBudgetDomain

public struct FilterRowViewDataMock: FilterRowViewDataProtocol {
    public var id: String = UUID().uuidString
    public var name: String = .someWord()
    public var color: Color = .random
    public var icon: RefdsIconSymbol? = .random
    
    public init() {}
}
