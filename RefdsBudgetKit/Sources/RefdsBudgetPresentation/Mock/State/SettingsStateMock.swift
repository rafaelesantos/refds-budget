import SwiftUI
import StoreKit
import RefdsBudgetData
import RefdsBudgetResource

public struct SettingsStateMock: SettingsStateProtocol {
    public var isLoading: Bool = true
    public var isPro: Bool = false
    public var isAcceptedTerms: Bool = false
    public var colorScheme: ColorScheme? = .allCases.randomElement()
    public var tintColor: Color = .accentColor
    public var hasAuthRequest: Bool = true
    public var hasPrivacyMode: Bool = true
    public var icon: Asset = .default
    public var icons: [Asset] = Asset.allCases
    public var selectedProduct: Product?
    public var products: [Product] = []
    public var purchasedProductsID: Set<String> = []
    public var features: [PremiumFeatureViewDataProtocol] = (1 ... 10).map { _ in PremiumFeatureViewDataMock() }
    public var error: RefdsBudgetError? = nil
    
    public init() {}
}
