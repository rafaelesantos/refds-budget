import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsShared
import RefdsBudgetPresentation

public struct AddCategoryView: View {
    @Binding private var state: AddCategoryStateProtocol
    private let action: (AddCategoryAction) -> Void
    
    @State private var iconPrefix = 15
    
    private var bindingHexColor: Binding<String> {
        Binding {
            state.color.asHex()
        } set: {
            state.color = Color(hex: $0)
        }
    }
    
    private var bindingName: Binding<String> {
        Binding {
            state.name
        } set: {
            state.name = $0
        }
    }
    
    public init(
        state: Binding<AddCategoryStateProtocol>,
        action: @escaping (AddCategoryAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    public var body: some View {
        List {
            sectionNameView
            sectionColorsView
            sectionIconsView
            sectionSaveButtonView
        }
        .refdsDismissesKeyboad()
        .onAppear { action(.fetchCategory(state)) }
        .refdsToast(item: $state.error)
    }
    
    private var sectionNameView: some View {
        RefdsSection {} footer: {
            #if os(macOS)
            RefdsTextField(
                .localizable(by: .addCategoryInputName),
                text: bindingName,
                axis: .vertical,
                style: .largeTitle,
                color: .primary,
                weight: .bold,
                alignment: .center
            )
            #else
            RefdsTextField(
                .localizable(by: .addCategoryInputName),
                text: bindingName,
                axis: .vertical,
                style: .largeTitle,
                color: .primary,
                weight: .bold,
                alignment: .center,
                textInputAutocapitalization: .words
            )
            #endif
        }
    }
    
    private var sectionColorsView: some View {
        RefdsSection {
            rowColors
            rowHexColor
        } header: {
            RefdsText(
                .localizable(by: .addCategoryColorHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var rowColors: some View {
        HStack(spacing: .padding(.medium)) {
            bubbleColorView(for: state.color, isSelected: true)
            Divider().frame(height: 30)
            ScrollView(.horizontal) {
                HStack {
                    let colors = Color.Default.allCases.sorted(by: { $0.id < $1.id })
                    ForEach(colors, id: \.self) { color in
                        RefdsButton {
                            state.color = color.rawValue
                        } label: {
                            bubbleColorView(for: color.rawValue)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.never)
            .padding(.horizontal, -20)
        }
    }
    
    private func bubbleColorView(for color: Color, isSelected: Bool = false) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 30, height: 30)
            if isSelected {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 10, height: 10)
            }
        }
        .animation(.default, value: color)
        .padding(.vertical, .padding(.extraSmall))
    }
    
    private var rowHexColor: some View {
        HStack {
            RefdsText(
                .localizable(by: .addCategoryInputHex),
                style: .callout
            )
            Spacer()
            RefdsTextField(
                Color.green.asHex(),
                text: bindingHexColor,
                style: .callout,
                alignment: .trailing
            )
        }
    }
    
    private var sectionIconsView: some View {
        RefdsSection {
            rowSelectedIcon
            rowIcons
            rowShowMoreIcons
        } header: {
            RefdsText(
                .localizable(by: .addCategoryIconsHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var rowSelectedIcon: some View {
        HStack {
            RefdsText(
                .localizable(by: .addCategorySelectedIcon),
                style: .callout
            )
            Spacer()
            RefdsText(
                state.icon.replacingOccurrences(of: ".", with: " ").capitalized,
                style: .callout,
                color: .secondary
            )
        }
    }
    
    private var rowIcons: some View {
        LazyVGrid(columns: iconsLayoutColumns) {
            let icons = RefdsIconSymbol.categoryIcons.prefix(iconPrefix)
            let selectedIcon = RefdsIconSymbol(rawValue: state.icon)
            ForEach(icons, id: \.self) { icon in
                RefdsButton {
                    state.icon = icon.rawValue
                } label: {
                    RefdsIcon(
                        icon,
                        color: icon == selectedIcon ? state.color : .primary,
                        size: 18,
                        renderingMode: .hierarchical
                    )
                    .frame(width: 38, height: 38)
                    .background(icon == selectedIcon ? state.color.opacity(0.2) : nil)
                    .clipShape(.rect(cornerRadius: 8))
                    .padding(.padding(.extraSmall))
                    .animation(.default, value: state.icon)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    @ViewBuilder
    private var rowShowMoreIcons: some View {
        let max = RefdsIconSymbol.categoryIcons.count
        let isMax = iconPrefix == max
        RefdsButton {
            withAnimation { 
                iconPrefix = isMax ? 15 : max
            }
        } label: {
            HStack(spacing: .padding(.medium)) {
                RefdsText(isMax ? .localizable(by: .addCategoryShowLessIcons) : .localizable(by: .addCategoryShowMoreIcons), style: .callout)
                Spacer(minLength: .zero)
                RefdsText((isMax ? 15 : max).asString, style: .callout, color: .secondary)
                RefdsIcon(isMax ? .chevronUp : .chevronDown, color: .placeholder)
            }
        }
    }
    
    private var iconsLayoutColumns: [GridItem] {
        [.init(.adaptive(minimum: 50, maximum: 100))]
    }
    
    private var sectionSaveButtonView: some View {
        RefdsSection {} footer: {
            RefdsButton(
                .localizable(by: .addCategorySaveCategoryButton),
                isDisable: !state.canSave
            ) {
                action(.save(state))
            }
            .padding(.horizontal, -20)
        }
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = RefdsReduxStoreFactory(mock: true).mock
        
        var body: some View {
            AddCategoryView(state: $store.state.addCategoryState) {
                store.dispatch(action: $0)
            }
        }
    }
    return ContainerView()
}

