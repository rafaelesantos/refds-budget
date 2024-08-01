import SwiftUI
import StoreKit
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class StoreMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var settingsRepository: SettingsUseCase
    
    private let monthlySubscriptionID = "br.com.refds.budget.pro.1month"
    private let semiannualSubscriptionID = "br.com.refds.budget.pro.6months"
    private let yearlySubscriptionID = "br.com.refds.budget.pro.1year"
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        switch action {
        case let action as SettingsAction: self.handler(with: state.settingsState, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: SettingsStateProtocol,
        for action: SettingsAction,
        on completion: @escaping (SettingsAction) -> Void
    ) {
        switch action {
        case .fetchData, .fetchStore: fetchData(with: state, on: completion)
        case .restore: restore(with: state, on: completion)
        case .updatePro: updatePro(with: state, on: completion)
        case .purchase: purchase(
            with: state,
            on: completion
        )
        default: break
        }
    }
    
    private func fetchData(
        with state: SettingsStateProtocol,
        on completion: @escaping (SettingsAction) -> Void
    ) {
        Task {
            let productIDs = [
                monthlySubscriptionID,
                semiannualSubscriptionID,
                yearlySubscriptionID
            ]
            do {
                let products = try await Product.products(for: productIDs)
                let features = getFeatures()
                var newState = state
                newState.products = products
                newState.features = features
                
                let isEmptyProducts = state.products.isEmpty
                
                await updatePurchasedProducts(
                    with: newState,
                    isEmptyProducts: isEmptyProducts,
                    on: completion
                )
            } catch {
                completion(.updateError(error: .notFoundProducts))
            }
        }
    }
    
    private func purchase(
        with state: SettingsStateProtocol,
        on completion: @escaping (SettingsAction) -> Void
    ) {
        guard state.isAcceptedTerms else { return completion(.updateError(error: .acceptTerms)) }
        guard let product = state.selectedProduct else { return completion(.updateError(error: .notFoundProducts)) }
        processPurchase(with: state, for: product, on: completion)
    }
    
    private func processPurchase(
        with state: SettingsStateProtocol,
        for product: Product,
        on completion: @escaping (SettingsAction) -> Void
    ) {
        Task {
            guard let result = try? await product.purchase() else { return completion(.updateError(error: .purchase)) }
            switch result {
            case let .success(.verified(transaction)): await transaction.finish()
            case .success(.unverified(_, _)): completion(.updateError(error: .purchase))
            case .pending: break
            case .userCancelled: break
            default: break
            }
            await updatePurchasedProducts(with: state, on: completion)
        }
    }
    
    private func restore(
        with state: SettingsStateProtocol,
        on completion: @escaping (SettingsAction) -> Void
    ) {
        Task {
            do {
                try await AppStore.sync()
                await updatePurchasedProducts(with: state, on: completion)
            } catch {
                completion(.updateError(error: .purchase))
            }
        }
    }
    
    private func updatePurchasedProducts(
        with state: SettingsStateProtocol,
        isEmptyProducts: Bool = false,
        on completion: @escaping (SettingsAction) -> Void
    ) async {
        var transactions: [StoreKit.Transaction] = []
        var purchasedProductsID = Set<String>()
        
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            transactions += [transaction]
            if transaction.revocationDate == nil {
                purchasedProductsID.insert(transaction.productID)
            } else {
                purchasedProductsID.remove(transaction.productID)
            }
        }
        
        transactions.sort(by: {
            $0.expirationDate ?? .current >
            $1.expirationDate ?? .current
        })
        
        if state.purchasedProductsID != purchasedProductsID ||
            state.transactions != transactions ||
            isEmptyProducts {
            completion(
                .receiveProducts(
                    products: state.products,
                    features: state.features,
                    productsID: purchasedProductsID,
                    transactions: transactions
                )
            )
        }
    }
    
    private func updatePro(
        with state: SettingsStateProtocol,
        on completion: @escaping (SettingsAction) -> Void
    ) {
        let isPro = !state.purchasedProductsID.isEmpty
        let appearence: Int = isPro ? (state.colorScheme == .none ? .zero : state.colorScheme == .light ? 1 : 2) : .zero
        let tintColor = isPro ? state.tintColor : Color(hex: "#28CD41")
        let hasAuthRequest = isPro ? state.hasAuthRequest : false
        let hasPrivacyMode = isPro ? state.hasPrivacyMode : false
        try? settingsRepository.addSettings(
            theme: tintColor,
            icon: state.icon,
            isAnimatedIcon: state.isAnimatedIcon,
            appearence: Double(appearence),
            hasAuthRequest: hasAuthRequest,
            hasPrivacyMode: hasPrivacyMode,
            notifications: nil,
            reminderNotification: nil,
            warningNotification: nil,
            breakingNotification: nil,
            currentWarningNotificationAppears: nil,
            currentBreakingNotificationAppears: nil,
            liveActivity: nil,
            isPro: isPro
        )
        completion(.fetchData)
    }
    
    private func getFeatures() -> [PremiumFeatureViewDataProtocol] {
        [
            PremiumFeatureViewData(title: .localizable(by: .subscriptionFeatureTitle1), isFree: true, isPro: true),
            PremiumFeatureViewData(title: .localizable(by: .subscriptionFeatureTitle2), isFree: true, isPro: true),
            PremiumFeatureViewData(title: .localizable(by: .subscriptionFeatureTitle3), isFree: true, isPro: true),
            PremiumFeatureViewData(title: .localizable(by: .subscriptionFeatureTitle4), isFree: true, isPro: true),
            PremiumFeatureViewData(title: .localizable(by: .subscriptionFeatureTitle5), isFree: false, isPro: true),
            PremiumFeatureViewData(title: .localizable(by: .subscriptionFeatureTitle6), isFree: false, isPro: true),
            PremiumFeatureViewData(title: .localizable(by: .subscriptionFeatureTitle7), isFree: false, isPro: true),
            PremiumFeatureViewData(title: .localizable(by: .subscriptionFeatureTitle8), isFree: false, isPro: true),
            PremiumFeatureViewData(title: .localizable(by: .subscriptionFeatureTitle9), isFree: false, isPro: true),
            PremiumFeatureViewData(title: .localizable(by: .subscriptionFeatureTitle10), isFree: false, isPro: true),
            PremiumFeatureViewData(title: .localizable(by: .subscriptionFeatureTitle11), isFree: false, isPro: true),
            PremiumFeatureViewData(title: .localizable(by: .subscriptionFeatureTitle12), isFree: false, isPro: true)
        ]
    }
}
