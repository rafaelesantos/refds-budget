import SwiftUI
import RefdsUI
import StoreKit
import RefdsRedux
import RefdsBudgetResource
import RefdsBudgetPresentation

public struct SubscriptionView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isPro) private var isPro
    @Environment(\.openURL) private var openURL
    
    @Binding private var state: SettingsStateProtocol
    private let action: (SettingsAction) -> Void
    
    public init(
        state: Binding<SettingsStateProtocol>,
        action: @escaping (SettingsAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    public var body: some View {
        contentView
            .frame(maxWidth: .infinity)
        #if os(iOS)
            .toolbar(.hidden, for: .navigationBar)
        #endif
            .onAppear { fetchData() }
            .task { setupPrice() }
    }
    
    private func setupPrice() {
        Task { @MainActor in
            withAnimation {
                state.selectedProduct = state.products.first
            }
        }
    }
    
    private func fetchData() {
        action(.fetchData)
    }
    
    private var contentView: some View {
        List {
            sectionHeaderView
            sectionCurrentProduct
            sectionFeatures
            sectionPrice
            sectionPurchaseInfo
            footerView
        }
        .scrollContentBackground(.hidden)
        .background(
            RefdsStarShower(
                from: .top,
                backgroundColor: .background(for: colorScheme)
            )
            .ignoresSafeArea()
        )
    }
    
    private var sectionHeaderView: some View {
        RefdsSection {} footer: {
            VStack {
                RefdsText(
                    isPro ? .localizable(by: .subscriptionWelcomePremium) : .localizable(by: .subscriptionBecomePremium),
                    style: .largeTitle,
                    weight: .black
                )
                .refdsBackground()
                .padding(.top, 30)
                
                RefdsText(
                    .localizable(by: .subscriptionNavigationTitle),
                    style: .largeTitle,
                    color: .accentColor,
                    weight: .black
                )
                .refdsBackground()
                
                RefdsText(
                    isPro ? .localizable(by: .subscriptionSubtitlePro) : .localizable(by: .subscriptionSubtitle),
                    style: .footnote,
                    color: .secondary,
                    alignment: .center
                )
                .refdsBackground()
                .padding(.top, 10)
                
                Divider()
                    .refdsBackground()
                    .padding(.horizontal, .padding(.extraLarge))
                    .padding(.top)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, .padding(.extraLarge))
            .padding(.top, -20)
        }
    }
    
    private var sectionFeatures: some View {
        RefdsSection {
            ForEach(state.features.indices, id: \.self) {
                let feature = state.features[$0]
                HStack(spacing: .zero) {
                    RefdsText(
                        feature.title,
                        style: .callout,
                        lineLimit: 1
                    )
                    
                    Spacer(minLength: .zero)
                    
                    if !isPro {
                        RefdsIcon(
                            feature.isFree ? .checkmarkRectangleFill : .xmarkRectangleFill,
                            color: feature.isFree ? .green : .red,
                            renderingMode: .hierarchical
                        )
                        .frame(width: 62)
                    }
                    
                    RefdsIcon(
                        feature.isPro ? .checkmarkRectangleFill : .xmarkRectangleFill,
                        color: feature.isPro ? .green : .red,
                        renderingMode: .hierarchical
                    )
                    .frame(width: 62)
                }
            }
        } header: {
            HStack(spacing: .zero) {
                RefdsText(
                    .localizable(by: .subscriptionFeaturesHeader),
                    style: .footnote,
                    color: .secondary
                )
                .refdsBackground()
                
                Spacer(minLength: .zero)
                
                if !isPro {
                    RefdsText(
                        .localizable(by: .subscriptionFreeHeader),
                        style: .footnote,
                        color: .secondary
                    )
                    .refdsBackground()
                    .frame(width: 62)
                }
                
                RefdsText(
                    .localizable(by: .subscriptionPremiumHeader),
                    style: .footnote,
                    color: .secondary
                )
                .refdsBackground()
                .frame(width: 62)
            }
        }
    }
    
    private var bindingProduct: Binding<String> {
        Binding {
            state.selectedProduct?.id ?? ""
        } set: { id in
            if let product = state.products.first(where: { $0.id == id }) {
                withAnimation {
                    state.selectedProduct = product
                }
            }
        }
    }
    
    @ViewBuilder
    private var sectionPrice: some View {
        if !isPro, let product = state.selectedProduct {
            RefdsSection {
                Picker(selection: bindingProduct) {
                    ForEach(state.products.indices, id: \.self) {
                        let product = state.products[$0]
                        RefdsText(product.displayName)
                            .tag(product.id)
                    }
                } label: {
                    RefdsText(.localizable(by: .subscriptionRowSelectPlan))
                }
                .tint(.accentColor)
                
                HStack {
                    VStack(alignment: .leading) {
                        RefdsText(
                            product.displayName.uppercased(),
                            style: .footnote,
                            color: .accentColor,
                            weight: .bold
                        )
                        .transition(.scale)
                        .padding(3)
                        .refdsTag(color: .accentColor, cornerRadius: 6)
                        
                        RefdsText(product.description)
                    }
                    
                    Spacer(minLength: .zero)
                    
                    VStack(alignment: .trailing) {
                        RefdsText(
                            .localizable(by: .subscriptionPriceHeader).uppercased(),
                            style: .footnote,
                            color: .secondary
                        )
                        
                        RefdsText(
                            product.displayPrice,
                            style: .largeTitle,
                            color: .accentColor,
                            weight: .black,
                            alignment: .center
                        )
                        .contentTransition(.numericText())
                    }
                }
            } header: {
                RefdsText(
                    .localizable(by: .subscriptionPlansHeader),
                    style: .footnote,
                    color: .secondary
                )
                .refdsBackground()
            }
        }
    }
    
    @ViewBuilder
    private var sectionCurrentProduct: some View {
        if isPro,
           let transaction = state.transactions.first,
           let product = state.products.first(where: { $0.id == transaction.productID }) {
            RefdsSection {
                HStack {
                    VStack(alignment: .leading) {
                        RefdsText(product.displayName, weight: .bold)
                        RefdsText(product.description, style: .callout, color: .secondary)
                    }
                    
                    Spacer(minLength: .zero)
                    
                    RefdsText(
                        product.displayPrice,
                        style: .largeTitle,
                        color: .accentColor,
                        weight: .black
                    )
                }
                
                HStack {
                    RefdsText(
                        .localizable(by: .subscriptionCurrentPlanPurchaseDate),
                        style: .callout
                    )
                    Spacer(minLength: .zero)
                    RefdsText(
                        transaction.purchaseDate.asString(withDateFormat: .custom("EEEE dd, MMMM yyyy")).capitalized,
                        style: .callout,
                        color: .secondary
                    )
                }
                
                HStack {
                    RefdsText(
                        .localizable(by: .subscriptionCurrentPlanRemaining),
                        style: .callout
                    )
                    Spacer(minLength: .zero)
                    RefdsText(
                        remainingDay(from: transaction).uppercased(),
                        style: .footnote,
                        color: .accentColor,
                        weight: .bold
                    )
                    .refdsTag(color: .accentColor)
                }
            } header: {
                RefdsText(
                    .localizable(by: .subscriptionCurrentPlan),
                    style: .footnote,
                    color: .secondary
                )
                .refdsBackground()
            }
        }
    }
    
    @ViewBuilder
    private var sectionPurchaseInfo: some View {
        if let product = state.selectedProduct {
            RefdsSection {} footer: {
                RefdsText(
                    .localizable(
                        by: .subscriptionPriceObsevations,
                        with: product.displayName, product.displayName
                    ).capitalizedSentence,
                    style: .footnote,
                    color: .secondary,
                    alignment: .center
                )
                .refdsBackground()
                .padding(.horizontal, -20)
            }
        }
    }
    
    @ViewBuilder
    private var footerView: some View {
        purchaseButton
        manageSubscriptionButton
    }
    
    @ViewBuilder
    private var purchaseButton: some View {
        if !isPro {
            RefdsSection {} footer: {
                VStack(spacing: .zero) {
                    Divider()
                        .padding(.horizontal, .padding(.extraLarge))
                    
                    if let selectedProduct = state.selectedProduct {
                        VStack(spacing: .padding(.small)) {
                            RefdsToggle(isOn: $state.isAcceptedTerms, style: .checkmark) {
                                RefdsText(
                                    .localizable(by: .subscriptionTermsDescription),
                                    style: .footnote,
                                    color: .secondary
                                )
                            }
                            .refdsBackground()
                            
                            RefdsButton(
                                .localizable(
                                    by: .subscriptionButton,
                                    with: selectedProduct.displayPrice, selectedProduct.displayName
                                ).uppercased(),
                                isDisable: !state.isAcceptedTerms
                            ) {
                                action(.purchase)
                            }
                            .contentTransition(.numericText())
                            .refdsBackground()
                            
                            RefdsButton { action(.restore) } label: {
                                RefdsText(
                                    .localizable(by: .subscriptionButtonRestore).uppercased(),
                                    style: .footnote,
                                    color: .accentColor,
                                    weight: .bold
                                )
                                .refdsTag(color: .accentColor)
                            }
                            .refdsBackground()
                            
                            RefdsButton { openURL(.budget(for: .privacyPolicy)) } label: {
                                RefdsText(
                                    .localizable(by: .subscriptionTermsButton),
                                    style: .footnote,
                                    color: .accentColor
                                )
                            }
                            .refdsBackground()
                        }
                        .padding(.vertical, .padding(.large))
                        .padding(.horizontal, -20)
                    }
                }
                .refdsBackground()
            }
        }
    }
    
    private func remainingDay(from transaction: StoreKit.Transaction) -> String {
        let expirationDate = transaction.expirationDate ?? .current
        let remainingDays = Calendar.current.dateComponents([.day], from: transaction.purchaseDate, to: expirationDate).day
        return (remainingDays ?? .zero).asString
    }
    
    @ViewBuilder
    private var manageSubscriptionButton: some View {
        if isPro {
            RefdsSection {} footer: {
                VStack(spacing: .zero) {
                    Divider()
                        .padding(.horizontal, .padding(.extraLarge))
                    
                    if let transaction = state.transactions.first {
                        VStack(spacing: .padding(.small)) {
                            let expirationDate = transaction.expirationDate ?? .current
                            let dateString = expirationDate.asString(withDateFormat: .custom("EEEE dd, MMMM yyyy")).capitalized
                            let remainingString = remainingDay(from: transaction)
                            RefdsText(
                                .localizable(by: .subscriptionExpirationDate, with: remainingString, dateString),
                                style: .footnote,
                                color: .secondary,
                                alignment: .center
                            )
                            
                            RefdsButton(
                                .localizable(by: .subscriptionManageButton)
                            ) {
                                openURL(.budget(for: .manageSubscription))
                            }
                            
                            RefdsButton { openURL(.budget(for: .privacyPolicy)) } label: {
                                RefdsText(
                                    .localizable(by: .subscriptionTermsButton),
                                    style: .footnote,
                                    color: .accentColor
                                )
                            }
                        }
                        .padding(.vertical, .padding(.large))
                        .padding(.horizontal, -20)
                    }
                }
                .refdsBackground()
            }
        }
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = RefdsReduxStoreFactory(mock: true).mock
        
        var body: some View {
            NavigationStack {
                SubscriptionView(state: $store.state.settingsState) {
                    store.dispatch(action: $0)
                }
            }
        }
    }
    return ContainerView()
}
