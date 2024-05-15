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
        case .fetchData: fetchData(on: completion)
        case .restore: restore(on: completion)
        case .purchase: purchase(
            with: state,
            on: completion
        )
        default: break
        }
    }
    
    private func fetchData(on completion: @escaping (SettingsAction) -> Void) {
        Task {
            let productIDs = [
                monthlySubscriptionID,
                semiannualSubscriptionID,
                yearlySubscriptionID
            ]
            do {
                let products = try await Product.products(for: productIDs)
                completion(
                    .receiveProducts(
                        products: products.sorted(by: { $0.price > $1.price }),
                        features: getFeatures()
                    )
                )
                updatePurchasedProducts(on: completion)
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
        processPurchase(for: product, on: completion)
    }
    
    private func processPurchase(
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
            updatePurchasedProducts(on: completion)
        }
    }
    
    private func restore(on completion: @escaping (SettingsAction) -> Void) {
        Task {
            do {
                try await AppStore.sync()
                updatePurchasedProducts(on: completion)
            } catch {
                completion(.updateError(error: .purchase))
            }
        }
    }
    
    private func updatePurchasedProducts(on completion: @escaping (SettingsAction) -> Void) {
        Task {
            for await result in Transaction.currentEntitlements {
                guard case .verified(let transaction) = result else { continue }
                if transaction.revocationDate == nil {
                    completion(.insertPurchased(id: transaction.productID))
                } else {
                    completion(.removePurchased(id: transaction.productID))
                }
            }
        }
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
