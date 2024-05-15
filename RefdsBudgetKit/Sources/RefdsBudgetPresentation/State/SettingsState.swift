import SwiftUI
import StoreKit
import RefdsRedux
import RefdsBudgetData
import RefdsBudgetResource

public protocol SettingsStateProtocol: RefdsReduxState {
    var isLoading: Bool { get set }
    var isPro: Bool { get set }
    var isAcceptedTerms: Bool { get set }
    var hasAuthRequest: Bool { get set }
    var hasPrivacyMode: Bool { get set }
    var colorScheme: ColorScheme? { get set }
    var tintColor: Color { get set }
    var icon: Asset { get set }
    var icons: [Asset] { get set }
    var selectedProduct: Product? { get set }
    var products: [Product] { get set }
    var purchasedProductsID: Set<String> { get set }
    var features: [PremiumFeatureViewDataProtocol] { get set }
    var transactions: [StoreKit.Transaction] { get set }
    var error: RefdsBudgetError? { get set }
}

public struct SettingsState: SettingsStateProtocol {
    public var isLoading: Bool
    public var isPro: Bool
    public var isAcceptedTerms: Bool
    public var colorScheme: ColorScheme?
    public var tintColor: Color
    public var hasAuthRequest: Bool
    public var hasPrivacyMode: Bool
    public var icon: Asset
    public var icons: [Asset]
    public var selectedProduct: Product?
    public var products: [Product]
    public var purchasedProductsID: Set<String>
    public var features: [PremiumFeatureViewDataProtocol]
    public var transactions: [StoreKit.Transaction]
    public var error: RefdsBudgetError?
    
    public init(
        isLoading: Bool = true,
        isPro: Bool = false,
        isAcceptedTerms: Bool = false,
        colorScheme: ColorScheme? = nil,
        tintColor: Color = .green,
        hasAuthRequest: Bool = false,
        hasPrivacyMode: Bool = false,
        icon: Asset = .default,
        icons: [Asset] = Asset.allCases,
        products: [Product] = [],
        purchasedProductsID: Set<String> = [],
        features: [PremiumFeatureViewDataProtocol] = [],
        transactions: [StoreKit.Transaction] = [],
        error: RefdsBudgetError? = nil
    ) {
        self.isLoading = isLoading
        self.isPro = isPro
        self.isAcceptedTerms = isAcceptedTerms
        self.colorScheme = colorScheme
        self.tintColor = tintColor
        self.hasAuthRequest = hasAuthRequest
        self.hasPrivacyMode = hasPrivacyMode
        self.icon = icon
        self.icons = icons
        self.products = products
        self.purchasedProductsID = purchasedProductsID
        self.features = features
        self.transactions = transactions
        self.error = error
    }
}

public extension Optional<ColorScheme> {
    var description: String {
        switch self {
        case .light: return .localizable(by: .settingsRowAppearenceLight)
        case .dark: return .localizable(by: .settingsRowAppearenceDark)
        default: return .localizable(by: .settingsRowAppearenceSystem)
        }
    }
}

private struct PrivacyModeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

private struct ProEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

public extension EnvironmentValues {
    var privacyMode: Bool {
        get { self[PrivacyModeEnvironmentKey.self] }
        set { self[PrivacyModeEnvironmentKey.self] = newValue }
    }
    
    var isPro: Bool {
        get { self[ProEnvironmentKey.self] }
        set { self[ProEnvironmentKey.self] = newValue }
    }
}
