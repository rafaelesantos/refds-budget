import SwiftUI

public struct TagRowViewDataMock: TagRowViewDataProtocol {
    public var id: UUID = .init()
    public var name: String = .someWord()
    public var color: Color = .random
    public var value: Double? = .random(in: 250 ... 750)
    public var amount: Int? = .random(in: 1 ... 1000)
    public var isAnimate: Bool = false
    
    public init() {}
}
