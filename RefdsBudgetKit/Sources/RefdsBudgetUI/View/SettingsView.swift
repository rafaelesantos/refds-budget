import SwiftUI
import RefdsUI
import RefdsInjection
import RefdsGamification
import RefdsRedux
import RefdsBudgetResource
import RefdsBudgetPresentation

public struct SettingsView: View {
    @RefdsInjection private var iconFactory: IconFactoryProtocol
    @Environment(\.applicationState) private var applicationState
    @Environment(\.itemNavigation) private var itemNavigation
    @Environment(\.requestReview) private var requestReview
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.openURL) private var openURL
    @Environment(\.isPro) private var isPro
    @Environment(\.navigate) private var navigate
    
    @State private var tintColor: Color = .accentColor
    
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
            if isPro { sectionCustomization }
            sectionIcons
            sectionSecurity
            sectionFiles
            sectionMoreOptions
            sectionAbout
        }
        .navigationTitle(String.localizable(by: .settingsNavigationTitle))
        .onAppear { reloadData() }
        .onChange(of: state.colorScheme) { updateData() }
        .onChange(of: state.tintColor) { updateData() }
        .onChange(of: state.icon) { updateData() }
        .onChange(of: state.hasAuthRequest) { updateData() }
        .onChange(of: state.hasPrivacyMode) { updateData() }
        .onChange(of: state.isAnimatedIcon) { updateData() }
        .onChange(of: tintColor) { state.tintColor = tintColor }
        .fileImporter(
            isPresented: $state.showDocumentPicker,
            allowedContentTypes: [.item],
            onCompletion: handlerDocument(for:)
        )
        .refdsToast(item: $state.error)
        .refdsShare(item: $state.share)
    }
    
    private func handlerDocument(for result: Result<URL, Error>) {
        switch result {
        case let .success(url):
            navigate?.to(url: url)
        case .failure:
            state.error = .notFoundBudget
        }
    }
    
    private func reloadData() {
        tintColor = state.tintColor
        action(.fetchData)
    }
    
    private func updateData() {
        Task(priority: .background) {
            action(.updateData)
        }
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
            RefdsIconRow(
                colorScheme == .dark ? .moonFill : .sunMaxFill,
                color: .indigo
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
            RefdsIconRow(
                .paintpaletteFill,
                color: .blue
            )
    
            ColorPicker(selection: $tintColor) {
                HStack {
                    RefdsText(.localizable(by: .settingsRowTheme))
                    Spacer(minLength: .zero)
                    #if os(iOS)
                    RefdsText(
                        UIColor(tintColor).accessibilityName.capitalized,
                        color: .secondary
                    )
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
                                iconFactory.setIcon(with: icon)
                            }
                        } label: {
                            VStack(spacing: .zero) {
                                icon.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60)
                                    .clipShape(.rect(cornerRadius: 13))
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
            .disabled(state.isAnimatedIcon)
            .budgetSubscription()
            
            HStack(spacing: .padding(.medium)) {
                RefdsIconRow(
                    .timelapse,
                    color: .teal
                )
                
                RefdsToggle(isOn: $state.isAnimatedIcon) {
                    RefdsText(.localizable(by: .settingsRowAnimatedIcons))
                }
            }
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
            Group {
                rowBiometry
                rowPrivacyMode
            }
            .budgetSubscription()
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
                Spacer(minLength: .zero)
            }
        }
    }
    
    private var rowBiometry: some View {
        HStack(spacing: .padding(.medium)) {
            RefdsIconRow(
                .lockShieldFill,
                color: .mint
            )
            RefdsToggle(isOn: $state.hasAuthRequest) {
                RefdsText(.localizable(by: .settingsRowFaceID))
            }
        }
    }
    
    private var rowPrivacyMode: some View {
        HStack(spacing: .padding(.medium)) {
            RefdsIconRow(
                .eyeSlashFill,
                color: .yellow
            )
            RefdsToggle(isOn: $state.hasPrivacyMode) {
                RefdsText(.localizable(by: .settingsRowPrivacyMode))
            }
        }
    }
    
    private var sectionFiles: some View {
        RefdsSection {
            Group {
                rowExportData
                rowImportData
            }
            .budgetSubscription()
        } header: {
            RefdsText(
                .localizable(by: .settingsFileHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var rowExportData: some View {
        RefdsButton {
            action(
                .share(
                    budgets: [],
                    categories: [],
                    transactions: []
                )
            )
        } label: {
            HStack(spacing: .padding(.medium)) {
                RefdsIconRow(
                    .docBadgeArrowUpFill,
                    color: .orange
                )
                RefdsText(.localizable(by: .settingsFileExport))
                Spacer(minLength: .zero)
            }
        }
    }
    
    private var rowImportData: some View {
        RefdsButton {
            withAnimation { state.showDocumentPicker.toggle() }
        } label: {
            HStack(spacing: .padding(.medium)) {
                RefdsIconRow(
                    .trayAndArrowDownFill,
                    color: .red
                )
                RefdsText(.localizable(by: .settingsFileImport))
                Spacer(minLength: .zero)
            }
        }
    }
    
    private var sectionMoreOptions: some View {
        RefdsSection {
            rowTestFlight
            rowAppReview
            rowPrivacyPolicy
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
                    color: .yellow
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
                    color: .green
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
        @StateObject private var store = StoreFactory.development
        
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
