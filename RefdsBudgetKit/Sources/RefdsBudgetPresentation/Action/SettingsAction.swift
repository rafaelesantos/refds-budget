import Foundation
import StoreKit
import RefdsRedux
import RefdsBudgetData

public enum SettingsAction: RefdsReduxAction {
    case purchase
    case restore
    case fetchData
    case updateData
    case updatePro(Bool)
    case receiveData(state: SettingsStateProtocol)
    case receiveProducts(
        products: [Product],
        features: [PremiumFeatureViewDataProtocol]
    )
    case updateError(error: RefdsBudgetError?)
    case insertPurchased(id: String)
    case removePurchased(id: String)
}
