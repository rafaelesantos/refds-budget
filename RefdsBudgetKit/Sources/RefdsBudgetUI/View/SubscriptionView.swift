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
        VStack(spacing: .zero) {
            headerView
            contentView
        }
        .frame(maxWidth: .infinity)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear { fetchData() }
        .task { setupPrice() }
        .refdsBackground(with: .secondaryBackground)
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
    
    private var headerView: some View {
        VStack {
            RefdsText(
                "Gastos Atualizados",
                style: .largeTitle,
                weight: .black,
                design: .rounded
            )
            .padding(.top, 30)
            
            RefdsText(
                "Budget App",
                style: .largeTitle,
                color: .accentColor,
                weight: .black,
                design: .rounded
            )
        }
        .frame(height: 400)
        .frame(maxWidth: .infinity)
        .background {
            RefdsStarShower(
                from: .top,
                galaxyHeight: 400,
                backgroundColor: Color.accentColor.opacity(0.1)
            )
            .opacity(0.8)
            .clipShape(.rect(cornerRadius: .cornerRadius))
        }
        .padding(.horizontal, -.padding(.extraLarge))
        .padding()
    }
    
    private var contentView: some View {
        List {
            sectionNote
            sectionCurrentProduct
            sectionFeatures
            sectionPrice
            sectionPurchaseInfo
            footerView
        }
    }
    
    private var sectionNote: some View {
        RefdsSection {
            
        } footer: {
            VStack(spacing: .padding(.medium)) {
                RefdsText(
                    isPro ? .localizable(by: .subscriptionSubtitlePro) : .localizable(by: .subscriptionSubtitle),
                    style: .footnote,
                    color: .secondary,
                    alignment: .center
                )
                .padding(.top, -20)
                
                Divider()
            }
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
                            feature.isFree ? .checkmarkSealFill : .xmarkSealFill,
                            color: feature.isFree ? .green : .red
                        )
                        .frame(width: 62)
                        
                        Divider()
                            .frame(height: 15)
                            .padding(.trailing, 5)
                    }
                    
                    RefdsIcon(
                        feature.isPro ? .checkmarkSealFill : .xmarkSealFill,
                        color: feature.isPro ? .green : .red
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
                
                Spacer(minLength: .zero)
                
                if !isPro {
                    RefdsText(
                        .localizable(by: .subscriptionFreeHeader),
                        style: .footnote,
                        color: .secondary
                    )
                    .frame(width: 62)
                    
                    Divider()
                        .frame(height: 15)
                        .padding(.trailing, 5)
                }
                
                RefdsText(
                    .localizable(by: .subscriptionPremiumHeader),
                    style: .footnote,
                    color: .secondary
                )
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
        if !isPro {
            RefdsSection {
                if state.selectedProduct != nil {
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
                }
            } header: {
                RefdsText(
                    .localizable(by: .subscriptionPlansHeader),
                    style: .footnote,
                    color: .secondary
                )
            } footer: {
                VStack {
                    if let product = state.selectedProduct {
                        VStack {
                            RefdsText(
                                .localizable(by: .subscriptionPriceHeader).uppercased(),
                                style: .footnote,
                                color: .secondary
                            )
                            
                            RefdsText(
                                product.displayPrice,
                                style: .system(size: 40),
                                color: .accentColor,
                                weight: .black,
                                alignment: .center
                            )
                            .contentTransition(.numericText())
                            
                            RefdsText(
                                product.description,
                                alignment: .center
                            )
                            .frame(width: 200)
                            .padding(.top, -20)
                            
                            RefdsText(
                                product.displayName.uppercased(),
                                style: .footnote,
                                color: .accentColor,
                                weight: .bold
                            )
                            .transition(.scale)
                            .padding(3)
                            .refdsTag(color: .accentColor, cornerRadius: 6)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, .padding(.large))
                .padding(.top, .padding(.extraLarge))
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
                        style: .title2,
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
                            
                            RefdsButton { action(.restore) } label: {
                                RefdsText(
                                    .localizable(by: .subscriptionButtonRestore).uppercased(),
                                    style: .footnote,
                                    color: .accentColor,
                                    weight: .bold
                                )
                                .refdsTag(color: .accentColor)
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
