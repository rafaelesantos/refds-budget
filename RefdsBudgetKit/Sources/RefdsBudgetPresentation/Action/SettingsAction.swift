import Foundation
import StoreKit
import RefdsRedux
import RefdsBudgetData

public enum SettingsAction: RefdsReduxAction {
    case purchase
    case restore
    case fetchData
    case fetchStore
    case updateData
    case updatePro
    case receiveData(state: SettingsStateProtocol)
    case receivePurchaseStatus(
        productsID: Set<String>,
        transactions: [StoreKit.Transaction]
    )
    case receiveProducts(
        products: [Product],
        features: [PremiumFeatureViewDataProtocol],
        productsID: Set<String>,
        transactions: [StoreKit.Transaction]
    )
    case updateShare(URL)
    case updateError(error: RefdsBudgetError?)
    case share(
        budgets: Set<UUID>,
        categories: Set<UUID>,
        transactions: Set<UUID>
    )
}
