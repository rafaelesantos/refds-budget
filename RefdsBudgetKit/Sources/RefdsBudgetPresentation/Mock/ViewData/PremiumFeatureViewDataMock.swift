import Foundation

public struct PremiumFeatureViewDataMock: PremiumFeatureViewDataProtocol {
    public var title: String = .someWord()
    public var isFree: Bool = .random()
    public var isPro: Bool = .random()
    
    public init() {}
}
