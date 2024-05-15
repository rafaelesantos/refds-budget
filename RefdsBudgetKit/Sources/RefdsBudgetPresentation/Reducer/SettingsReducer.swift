import Foundation
import RefdsRedux

public final class SettingsReducer: RefdsReduxReducerProtocol {
    public typealias State = SettingsStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? SettingsAction {
        case .fetchData:
            state.isLoading = true
        case let .receiveData(newState):
            state = newState
        case let .receiveProducts(products, features):
            state.products = products
            state.features = features
        case let .insertPurchased(id):
            state.purchasedProductsID.insert(id)
            state.isPro = !state.purchasedProductsID.isEmpty
        case let .removePurchased(id):
            state.purchasedProductsID.remove(id)
            state.isPro = !state.purchasedProductsID.isEmpty
        case let .updateError(error):
            state.error = error
        default: break
        }
        
        return state
    }
}
