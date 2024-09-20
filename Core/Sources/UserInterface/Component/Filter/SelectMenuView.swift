import SwiftUI
import RefdsUI
import RefdsShared
import Mock
import Domain
import Resource
import Presentation

public struct SelectMenuView: View {
    private let header: LocalizableKey
    private let icon: RefdsIconSymbol
    private let title: LocalizableKey
    
    private let items: [FilterItemViewDataProtocol]
    @Binding private var selectedItem: Set<String>
    
    public init(
        header: LocalizableKey,
        icon: RefdsIconSymbol,
        title: LocalizableKey,
        items: [FilterItemViewDataProtocol],
        selectedItem: Binding<Set<String>>
    ) {
        self.header = header
        self.icon = icon
        self.title = title
        self.items = items
        self._selectedItem = selectedItem
    }
    
    public var body: some View {
        Menu {
            menuHeader
            Divider()
            menuOptions
            Divider()
            menuFooter
        } label: {
            menuLabel
        }
    }
    
    private var menuHeader: some View {
        RefdsText(.localizable(by: header))
    }
    
    private var menuOptions: some View {
        ForEach(items.indices, id: \.self) {
            let item = items[$0]
            RefdsButton {
                if selectedItem.contains(item.name) {
                    selectedItem.remove(item.name)
                } else {
                    selectedItem.insert(item.name)
                }
            } label: {
                HStack {
                    let contains = selectedItem.contains(item.name)
                    
                    if let icon = item.icon, !contains {
                        RefdsIcon(icon)
                    }
                    
                    RefdsText(item.name.capitalized)
                    
                    if contains {
                        RefdsIcon(.checkmark)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var menuFooter: some View {
        if !selectedItem.isEmpty {
            RefdsButton {
                selectedItem = []
            } label: {
                Label(
                    String.localizable(by: .menuCleanSelections),
                    systemImage: RefdsIconSymbol.clear.rawValue
                )
            }
        }
    }
    
    private var menuLabel: some View {
        HStack(spacing: .medium) {
            RefdsText(.localizable(by: title), style: .callout)
            Spacer()
            menuLabelDetail
            RefdsIcon(icon)
        }
    }
    
    private var menuLabelDetail: some View {
        HStack {
            if selectedItem.count == 1 {
                RefdsText(selectedItem.first ?? "", style: .callout, color: .secondary)
            } else {
                RefdsText(
                    selectedItem.count == .zero ? .localizable(by: .transactionsCategoriesAllSelected) :
                        selectedItem.count.asString, style: .callout, color: .secondary
                )
            }
        }
    }
}


#Preview {
    List {
        SelectMenuView(
            header: .transactionsCategoriesFilterHeader,
            icon: .squareStack3dForwardDottedlineFill,
            title: .categoriesNavigationTitle,
            items: (1 ... 5).map { _ in FilterItemViewDataMock() },
            selectedItem: .constant([])
        )
        .environment(\.isPro, false)
    }
}
