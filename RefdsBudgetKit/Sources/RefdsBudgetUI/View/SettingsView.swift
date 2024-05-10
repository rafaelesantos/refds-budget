import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsBudgetResource
import RefdsBudgetPresentation

public struct SettingsView: View {
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
            sectionAbout
        }
        .navigationTitle("Configurações")
        .onAppear { reloadData() }
        .onChange(of: state.colorScheme) { updateData() }
        .onChange(of: state.tintColor) { updateData() }
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
                "Customização",
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
                RefdsText("Aparência")
            }
            .tint(.secondary)
        }
    }
    
    private var rowTintColor: some View {
        HStack(spacing: .padding(.medium)) {
            RefdsIconRow(.paintpaletteFill)
            
            ColorPicker(selection: $state.tintColor) {
                HStack {
                    RefdsText("Tema")
                    Spacer(minLength: .zero)
                    RefdsText(
                        UIColor(state.tintColor).accessibilityName.capitalized,
                        color: .secondary
                    )
                    .padding(.trailing, .padding(.small))
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
                    let icons = ApplicationIcon.allCases
                    ForEach(icons.indices, id: \.self) {
                        let icon = icons[$0]
                        let isSelected = icon == state.icon
                        RefdsButton {
                            withAnimation {
                                state.icon = icon
                            }
                            icon.changeIcon()
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
                RefdsText("Ícones", style: .footnote, color: .secondary)
                Spacer()
                RefdsText(state.icon.title, style: .footnote, color: .secondary)
            }
        }
        #endif
    }
    
    private var sectionAbout: some View {
        RefdsSection {
            rowDeveloper
        } header: {
            RefdsText("Sobre", style: .footnote, color: .secondary)
        }
    }
    
    private var rowDeveloper: some View {
        RefdsButton {
            if let url = URL(string: "https://github.com/rafaelesantos") {
                openURL(url)
            }
        } label: {
            HStack(spacing: .padding(.medium)) {
                RefdsAsyncImage(url: "https://gravatar.com/avatar/79e5c1241339f7834a159e6c0f644eaa0914c5d1c60d04f094322c0f0762c6e6") { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(.circle)
                        .padding(.vertical, 3)
                }
                
                VStack(alignment: .leading) {
                    RefdsText("Rafael Escaleira")
                    RefdsText("Desenvolvedor iOS na Globo", style: .callout, color: .secondary)
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
