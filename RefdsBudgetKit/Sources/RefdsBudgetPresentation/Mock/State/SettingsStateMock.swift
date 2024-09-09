import SwiftUI
import StoreKit
import RefdsBudgetDomain
import RefdsBudgetResource

public struct SettingsStateMock: SettingsStateProtocol {
    public var isLoading: Bool = true
    public var isPro: Bool = false
    public var isAcceptedTerms: Bool = false
    public var colorScheme: ColorScheme? = .none
    public var tintColor: Color = .green
    public var hasAuthRequest: Bool = true
    public var hasPrivacyMode: Bool = true
    public var icon: Asset = .appIcon
    public var isAnimatedIcon: Bool = .random()
    public var icons: [Asset] = Asset.allCases
    public var selectedProduct: Product?
    public var products: [Product] = []
    public var purchasedProductsID: Set<String> = []
    public var features: [PremiumFeatureViewDataProtocol] = (1 ... 10).map { _ in PremiumFeatureViewDataMock() }
    public var transactions: [StoreKit.Transaction] = []
    public var share: URL?
    public var showDocumentPicker: Bool = false
    public var error: RefdsBudgetError? = nil
    
    public init() {}
}
