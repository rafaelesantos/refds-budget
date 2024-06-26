import Foundation
import RefdsRedux

public final class SettingsReducer: RefdsReduxReducerProtocol {
    public typealias State = SettingsStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? SettingsAction {
        case .fetchData, .share:
            state.isLoading = true
        case let .receiveData(newState):
            state = newState
        case .updatePro:
            state.products = []
            state.features = []
            state.transactions = []
            state.purchasedProductsID = []
            state.isLoading = true
        case let .receiveProducts(
            products,
            features,
            productsID,
            transactions
        ):
            state.products = products
            state.features = features
            state.transactions = transactions
            state.purchasedProductsID = productsID
            state.isPro = !productsID.isEmpty
        case let .receivePurchaseStatus(productsID, transactions):
            break
        case let .updateError(error):
            state.error = error
        case let .updateShare(url):
            state.share = url
            state.isLoading = false
        default: break
        }
        
        return state
    }
}
