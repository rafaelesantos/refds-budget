import Foundation
import Domain

struct PremiumItemViewData: PremiumItemViewDataProtocol {
    var title: String
    var isFree: Bool
    var isPro: Bool
    
    init(
        title: String,
        isFree: Bool,
        isPro: Bool
    ) {
        self.title = title
        self.isFree = isFree
        self.isPro = isPro
    }
}
