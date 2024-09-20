import SwiftUI
import RefdsUI
import RefdsShared

struct IconFormView: View {
    @Binding private var icon: RefdsIconSymbol
    @State private var iconPrefix = 15
    
    private let color: Color
    private let size: CGFloat = 40
    
    init(icon: Binding<RefdsIconSymbol>, color: Color) {
        self._icon = icon
        self.color = color
    }
    
    var body: some View {
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
                color: color,
                size: size
            )
        }
    }
    
    private var rowIcons: some View {
        LazyVGrid(columns: iconsLayoutColumns, spacing: .medium) {
            let icons = RefdsIconSymbol.categoryIcons.prefix(iconPrefix)
            let selectedIcon = icon
            ForEach(icons, id: \.self) { icon in
                RefdsButton {
                    self.icon = icon
                } label: {
                    RefdsIcon(
                        icon,
                        color: icon == selectedIcon ? color : .primary,
                        size: size / 2,
                        renderingMode: .hierarchical
                    )
                    .frame(width: size, height: size)
                    .background(icon == selectedIcon ? color.opacity(0.2) : Color.secondary.opacity(0.1))
                    .refdsCornerRadius(for: size)
                    .padding(.vertical, size * 0.07)
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
            HStack(spacing: .medium) {
                RefdsText(isMax ? .localizable(by: .addCategoryShowLessIcons) : .localizable(by: .addCategoryShowMoreIcons), style: .callout)
                Spacer(minLength: .zero)
                RefdsText((isMax ? 15 : max).asString, style: .callout, color: .secondary)
                RefdsIcon(isMax ? .chevronUp : .chevronDown, color: .placeholder)
            }
        }
    }
    
    private var iconsLayoutColumns: [GridItem] {
        [.init(.adaptive(minimum: 55))]
    }
}

#Preview {
    struct ContentView: View {
        @State private var selectedIcon: RefdsIconSymbol = .dollarsign
        var body: some View {
            List {
                IconFormView(
                    icon: $selectedIcon,
                    color: .random
                )
            }
        }
    }
    return ContentView()
}
