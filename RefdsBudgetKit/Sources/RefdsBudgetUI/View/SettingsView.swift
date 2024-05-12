import SwiftUI
import RefdsUI
import StoreKit
import RefdsRedux
import RefdsBudgetResource
import RefdsBudgetPresentation

public struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.openURL) var openURL
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
        List {
            sectionCustomization
            sectionIcons
            sectionSecurity
            sectionMoreOptions
            sectionAbout
        }
        .navigationTitle(String.localizable(by: .settingsNavigationTitle))
        .onAppear { reloadData() }
        .onChange(of: state.colorScheme) { updateData() }
        .onChange(of: state.tintColor) { updateData() }
        .onChange(of: state.icon) { updateData() }
        .onChange(of: state.hasAuthRequest) { updateData() }
        .refdsToast(item: $state.error)
    }
    
    private func reloadData() {
        action(.fetchData)
    }
    
    private func updateData() {
        action(.updateData)
    }
    
    private var sectionCustomization: some View {
        RefdsSection {
            rowAppearence
            rowTintColor
        } header: {
            RefdsText(
                .localizable(by: .settingsSectionCustomization),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var rowAppearence: some View {
        HStack(spacing: .padding(.medium)) {
            let color: Color = colorScheme == .dark ? .purple : .yellow
            RefdsIconRow(
                colorScheme == .dark ? .moonFill : .sunMaxFill,
                color: color
            )
            
            Picker(selection: $state.colorScheme) {
                let schemes: [ColorScheme?] = ColorScheme.allCases + [.none]
                ForEach(schemes.indices, id: \.self) {
                    let scheme = schemes[$0]
                    RefdsText(scheme.description)
                        .tag(scheme)
                }
            } label: {
                RefdsText(.localizable(by: .settingsRowAppearence))
            }
            .tint(.secondary)
        }
    }
    
    private var rowTintColor: some View {
        HStack(spacing: .padding(.medium)) {
            RefdsIconRow(.paintpaletteFill)
            
            ColorPicker(selection: $state.tintColor) {
                HStack {
                    RefdsText(.localizable(by: .settingsRowTheme))
                    Spacer(minLength: .zero)
                    #if os(iOS)
                    RefdsText(
                        UIColor(state.tintColor).accessibilityName.capitalized,
                        color: .secondary
                    )
                    .padding(.trailing, .padding(.small))
                    #endif
                }
            }
        }
    }
    
    @ViewBuilder
    private var sectionIcons: some View {
        #if os(iOS)
        RefdsSection {
            ScrollView(.horizontal) {
                HStack(spacing: .padding(.large)) {
                    ForEach(state.icons.indices, id: \.self) {
                        let icon = state.icons[$0]
                        let isSelected = icon == state.icon
                        RefdsButton {
                            withAnimation {
                                state.icon = icon
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    icon.changeIcon()
                                }
                            }
                        } label: {
                            VStack(spacing: .zero) {
                                icon.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                    .clipShape(.rect(cornerRadius: .cornerRadius))
                                    .refdsCard(padding: .zero, hasShadow: true)
                                    .padding(.vertical, 15)
                                
                                RefdsIcon(isSelected ? .checkmarkCircleFill : .circle)
                                    .padding(.top, -5)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.never)
            .padding(.horizontal, -20)
        } header: {
            HStack {
                RefdsText(
                    .localizable(by: .settingsSectionIcons),
                    style: .footnote,
                    color: .secondary
                )
                Spacer()
                RefdsText(
                    state.icon.title,
                    style: .footnote,
                    color: .secondary
                )
            }
        }
        #endif
    }
    
    private var sectionSecurity: some View {
        RefdsSection {
            rowBiometry
            rowPrivacyPolicy
        } header: {
            RefdsText(
                .localizable(by: .settingsSectionSecurity),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var rowPrivacyPolicy: some View {
        RefdsButton {
            openURL(.budget(for: .privacyPolicy))
        } label: {
            HStack(spacing: .padding(.medium)) {
                RefdsIconRow(
                    .handRaisedFill,
                    color: .orange
                )
                RefdsText(.localizable(by: .settingsPrivacyPolicy))
            }
        }
    }
    
    private var rowBiometry: some View {
        HStack(spacing: .padding(.medium)) {
            RefdsIconRow(
                .lockShieldFill,
                color: .indigo
            )
            RefdsToggle(isOn: $state.hasAuthRequest) {
                RefdsText(.localizable(by: .settingsRowFaceID))
            }
        }
    }
    
    private var sectionMoreOptions: some View {
        RefdsSection {
            rowTestFlight
            rowAppReview
            rowAppShare
        } header: {
            RefdsText(
                .localizable(by: .settingsSectionMoreOptions),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var rowTestFlight: some View {
        RefdsButton {
            openURL(.budget(for: .jointTestFlight))
        } label: {
            HStack(spacing: .padding(.medium)) {
                RefdsIconRow(
                    .hammerFill,
                    color: .blue
                )
                RefdsText(.localizable(by: .settingsRowTestFlight))
                Spacer(minLength: .zero)
                RefdsText(
                    .localizable(by: .settingsTagBeta).uppercased(),
                    style: .footnote,
                    color: .accentColor,
                    weight: .bold
                )
                .refdsTag(color: .accentColor)
            }
        }
    }
    
    private var rowAppReview: some View {
        RefdsButton {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.requestReview()
            }
        } label: {
            HStack(spacing: .padding(.medium)) {
                RefdsIconRow(
                    .starFill,
                    color: .green
                )
                RefdsText(.localizable(by: .settingsRowReview))
                Spacer(minLength: .zero)
                RefdsText(.localizable(by: .settingsRowReviewDetail), color: .secondary)
            }
        }
    }
    
    private var rowAppShare: some View {
        ShareLink(item: .budget(for: .appleStoreReference)) {
            HStack(spacing: .padding(.medium)) {
                RefdsIconRow(
                    .squareAndArrowUp,
                    color: .pink
                )
                RefdsText(.localizable(by: .settingsRowShare))
            }
        }
    }
    
    private var sectionAbout: some View {
        RefdsSection {
            rowApplicationDetail
            rowDeveloper
        } header: {
            RefdsText(
                .localizable(by: .settingsSectionAbout),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var rowApplicationDetail: some View {
        HStack(spacing: .padding(.medium)) {
            state.icon.image
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33)
                .clipShape(.rect(cornerRadius: 8))
                .padding(.vertical, 4)
            
            HStack {
                RefdsText(.localizable(by: .settingsApplicationName))
                
                RefdsText(
                    .localizable(by: .settingsApplicationVersion),
                    color: .secondary
                )
            }
            
            Spacer(minLength: .zero)
            
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                RefdsText(
                    appVersion,
                    style: .footnote,
                    color: .accentColor,
                    weight: .bold
                )
                .refdsTag(color: .accentColor)
            }
        }
    }
    
    private var rowDeveloper: some View {
        RefdsButton {
            openURL(.budget(for: .developerGithub))
        } label: {
            HStack(spacing: .padding(.medium)) {
                RefdsAsyncImage(url: URL.budget(for: .developerImage).absoluteString) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(.circle)
                        .padding(.vertical, 3)
                }
                
                VStack(alignment: .leading) {
                    RefdsText("Rafael Escaleira")
                    RefdsText(.localizable(by: .settingsDevJob), style: .callout, color: .secondary)
                }
                
                Spacer(minLength: .zero)
                
                RefdsIcon(.chevronRight, color: .secondary.opacity(0.5))
            }
        }
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = RefdsReduxStoreFactory(mock: true).mock
        
        var body: some View {
            NavigationStack {
                SettingsView(state: $store.state.settingsState) {
                    store.dispatch(action: $0)
                }
            }
        }
    }
    return ContainerView()
}
