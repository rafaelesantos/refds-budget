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
        .overlay(alignment: .bottom) { purchaseButton }
        .toolbar(.hidden, for: .navigationBar)
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
    
    private var headerView: some View {
        VStack {
            RefdsText(
                isPro ? .localizable(by: .subscriptionWelcomePremium) : .localizable(by: .subscriptionBecomePremium),
                style: .largeTitle,
                weight: .black,
                design: .rounded
            )
            .padding(.top, 30)
            
            RefdsText(
                .localizable(by: .subscriptionNavigationTitle),
                style: .largeTitle,
                color: .accentColor,
                weight: .black,
                design: .rounded
            )
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background {
            RefdsStarShower(
                from: .top,
                galaxyHeight: 200,
                backgroundColor: Color.accentColor.opacity(0.1)
            )
            .opacity(0.8)
            .clipShape(.rect(cornerRadius: .cornerRadius))
        }
        .padding(.horizontal, -.padding(.extraLarge))
        .ignoresSafeArea(.all, edges: [.top, .leading, .trailing])
        .padding(.bottom, -60)
    }
    
    private var contentView: some View {
        List {
            sectionNote
            sectionFeatures
            sectionPrice
        }
    }
    
    private var sectionNote: some View {
        RefdsSection {
            
        } footer: {
            VStack(spacing: .padding(.medium)) {
                RefdsText(
                    .localizable(by: .subscriptionSubtitle),
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
                    
                    RefdsIcon(
                        feature.isFree ? .checkmarkSealFill : .xmarkSealFill,
                        color: feature.isFree ? .accentColor : .red
                    )
                        .frame(width: 62)
                    
                    Divider()
                        .frame(height: 15)
                        .padding(.trailing, 5)
                    
                    RefdsIcon(
                        feature.isPro ? .checkmarkSealFill : .xmarkSealFill,
                        color: feature.isPro ? .accentColor : .red
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
                
                RefdsText(
                    .localizable(by: .subscriptionFreeHeader),
                    style: .footnote,
                    color: .secondary
                )
                .frame(width: 62)
                
                Divider()
                    .frame(height: 15)
                    .padding(.trailing, 5)
                
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
    
    private var sectionPrice: some View {
        RefdsSection {
            if let selectedProduct = state.selectedProduct {
                Picker(selection: bindingProduct) {
                    ForEach(state.products.indices, id: \.self) {
                        let product = state.products[$0]
                        RefdsText(product.displayName)
                            .tag(product.id)
                    }
                } label: {
                    VStack(alignment: .leading, spacing: .zero) {
                        RefdsText(.localizable(by: .subscriptionRowSelectPlan))
                        RefdsText(
                            selectedProduct.description,
                            color: .secondary
                        )
                    }
                }
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
                            product.displayName.uppercased(),
                            style: .footnote,
                            weight: .black
                        )
                        .transition(.scale)
                        .padding(3)
                        .refdsTag(cornerRadius: 6)
                        .padding(.top, -20)
                    }
                    
                    RefdsText(
                        .localizable(
                            by: .subscriptionPriceObsevations,
                            with: product.displayName, product.displayName
                        ).capitalized,
                        style: .footnote,
                        color: .secondary
                    )
                    .padding(.top, 20)
                    .padding(.horizontal, -40)
                    .padding(.bottom, 150)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, .padding(.large))
            .padding(.top, .padding(.extraLarge))
        }
    }
    
    private var purchaseButton: some View {
        VStack {
            Divider()
                .padding(.horizontal, .padding(.extraLarge))
            if let selectedProduct = state.selectedProduct {
                VStack(spacing: .padding(.small)) {
                    RefdsToggle(isOn: $state.isAcceptedTerms, style: .checkmark) {
                        RefdsButton { openURL(.budget(for: .privacyPolicy)) } label: {
                            RefdsText(
                                .localizable(by: .subscriptionTermsDescription),
                                style: .footnote,
                                color: .secondary
                            )
                        }
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
                }
                .padding(.padding(.large))
            }
        }
        .refdsBackground(with: .secondaryBackground)
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
