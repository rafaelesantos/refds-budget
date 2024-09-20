import SwiftUI
import RefdsShared
import Domain

public struct FilterItemViewDataMock: FilterItemViewDataProtocol {
    public var id: String = UUID().uuidString
    public var name: String = .someWord()
    public var color: Color = .random
    public var icon: RefdsIconSymbol? = .random
    
    public init() {}
}
