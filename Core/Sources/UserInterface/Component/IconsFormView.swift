import SwiftUI
import RefdsUI
import RefdsShared

public struct IconsFormView: View {
    @Binding private var icon: RefdsIconSymbol
    @State private var iconPrefix = 15
    
    private let color: Color
    
    init(icon: Binding<RefdsIconSymbol>, color: Color) {
        self._icon = icon
        self.color = color
    }
    
    public var body: some View {
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
                icon.rawValue.replacingOccurrences(of: ".", with: " ").capitalized,
                style: .callout,
                color: .secondary
            )
            
            Spacer(minLength: .zero)
            
            RefdsIconRow(
                icon,
                color: color
            )
        }
    }
    
    private var rowIcons: some View {
        LazyVGrid(columns: iconsLayoutColumns) {
            let icons = RefdsIconSymbol.categoryIcons.prefix(iconPrefix)
            let selectedIcon = icon
            ForEach(icons, id: \.self) { icon in
                RefdsButton {
                    self.icon = icon
                } label: {
                    RefdsIcon(
                        icon,
                        color: icon == selectedIcon ? color : .primary,
                        size: 18,
                        renderingMode: .hierarchical
                    )
                    .frame(width: 38, height: 38)
                    .background(icon == selectedIcon ? color.opacity(0.2) : Color.secondary.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 8))
                    .padding(.padding(.extraSmall))
                    .animation(.default, value: icon)
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
        [.init(.adaptive(minimum: 50))]
    }
}

#Preview {
    IconsFormView(
        icon: .constant(.random),
        color: .random
    )
}
