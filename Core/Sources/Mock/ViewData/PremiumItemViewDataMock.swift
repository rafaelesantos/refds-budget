import Foundation
import Domain

public struct PremiumItemViewDataMock: PremiumItemViewDataProtocol {
    public var title: String = .someWord()
    public var isFree: Bool = .random()
    public var isPro: Bool = .random()
    
    public init() {}
}
