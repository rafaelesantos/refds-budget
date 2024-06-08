import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsShared
import RefdsBudgetPresentation

public struct AddCategoryView: View {
    @Binding private var state: AddCategoryStateProtocol
    private let action: (AddCategoryAction) -> Void
    
    @State private var iconPrefix = 15
    
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
        .toolbar { ToolbarItem { saveButtonToolbar } }
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
            BubbleColorView(color: state.color, isSelected: true)
            Divider().frame(height: 30)
            ScrollView(.horizontal) {
                HStack {
                    let colors = Color.Default.allCases.sorted(by: { $0.id < $1.id })
                    ForEach(colors, id: \.self) { color in
                        RefdsButton {
                            state.color = color.rawValue
                        } label: {
                            BubbleColorView(color: color.rawValue)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.never)
            .padding(.horizontal, -20)
        }
    }
    
    private var rowHexColor: some View {
        ColorPicker(selection: $state.color) {
            RefdsText(
                .localizable(by: .addCategoryInputHex),
                style: .callout
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
                state.icon.replacingOccurrences(of: ".", with: " ").capitalized,
                style: .callout,
                color: .secondary
            )
            
            Spacer(minLength: .zero)
            
            if let icon = RefdsIconSymbol(rawValue: state.icon) {
                RefdsIconRow(
                    icon,
                    color: state.color
                )
            }
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
                    .background(icon == selectedIcon ? state.color.opacity(0.2) : Color.secondary.opacity(0.1))
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
            .padding(.bottom, 20)
        }
    }
    
    private var saveButtonToolbar: some View {
        RefdsButton(isDisable: !state.canSave) { action(.save(state)) } label: {
            RefdsIcon(
                .checkmarkCircleFill,
                color: .accentColor,
                size: 18,
                weight: .bold,
                renderingMode: .hierarchical
            )
        }
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = StoreFactory.development
        
        var body: some View {
            AddCategoryView(state: $store.state.addCategoryState) {
                store.dispatch(action: $0)
            }
        }
    }
    return ContainerView()
}

