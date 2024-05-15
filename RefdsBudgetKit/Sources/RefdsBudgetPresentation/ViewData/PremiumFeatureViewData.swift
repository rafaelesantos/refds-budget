import Foundation

public protocol PremiumFeatureViewDataProtocol {
    var title: String { get set }
    var isFree: Bool { get set }
    var isPro: Bool { get set }
}

public struct PremiumFeatureViewData: PremiumFeatureViewDataProtocol {
    public var title: String
    public var isFree: Bool
    public var isPro: Bool
    
    public init(
        title: String,
        isFree: Bool,
        isPro: Bool
    ) {
        self.title = title
        self.isFree = isFree
        self.isPro = isPro
    }
}
