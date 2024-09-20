import SwiftUI
import RefdsUI
import RefdsShared
import Domain
import Mock

struct FilterView: View {
    @Binding private var viewData: FilterViewDataProtocol
    
    init(viewData: Binding<FilterViewDataProtocol>) {
        self._viewData = viewData
    }
    
    var body: some View {
        RefdsSection {
            menuView
            dateView
        } header: {
            selectedItemsView
        }
    }
    
    private var menuView: some View {
        Menu {
            menuContentView
        } label: {
            menuLabel
        }
    }
    
    private var menuLabel: some View {
        HStack {
            RefdsText(
                .localizable(by: .categoriesFilter),
                style: .callout
            )
            Spacer()
            RefdsText(
                viewData.items.count.asString,
                style: .callout,
                color: .secondary
            )
            RefdsIcon(
                .chevronUpChevronDown,
                color: .secondary.opacity(0.5),
                style: .callout
            )
        }
    }
    
    @ViewBuilder
    private var dateView: some View {
        if viewData.isDateFilter {
            DateRowView(date: $viewData.date)
        }
    }
    
    @ViewBuilder
    private var selectedItemsView: some View {
        let storiesViewData: [RefdsStoriesViewData] = viewData.items.map {
            getItemsRow(for: $0)
        }.flatMap { 
            $0
        }.filter {
            viewData.selectedItems.contains($0.name)
        }.compactMap {
            guard let icon = $0.icon else { return nil }
            return RefdsStoriesViewData(
                name: $0.name,
                color: $0.color,
                icon: icon
            )
        }
        
        if !storiesViewData.isEmpty {
            RefdsStories(
                selection: selectionStoriesItem,
                stories: storiesViewData,
                size: 45,
                spacing: .zero,
                showName: false,
                showAllSelected: true
            )
            .padding(.top, -20)
            .padding(.bottom, 10)
            .padding(.horizontal, -20)
        }
    }
    
    private var menuContentView: some View {
        ForEach(viewData.items.indices, id: \.self) {
            let item = viewData.items[$0]
            switch item {
            case .date: 
                dateToggleView
            case let .categories(items):
                SelectMenuRowView(
                    header: .transactionsCategoriesFilterHeader,
                    icon: .squareStack3dForwardDottedlineFill,
                    title: .categoriesNavigationTitle,
                    items: items,
                    selectedItem: $viewData.selectedItems
                )
            case let .tags(items):
                SelectMenuRowView(
                    header: .tagsMenuSelectHeader,
                    icon: .tagFill,
                    title: .tagsNavigationTitle,
                    items: items,
                    selectedItem: $viewData.selectedItems
                )
            case let .status(items):
                SelectMenuRowView(
                    header: .addTransactionStatusSelect,
                    icon: .listDashHeaderRectangle,
                    title: .addTransactionStatusHeader,
                    items: items,
                    selectedItem: $viewData.selectedItems
                )
            }
        }
    }
    
    private var dateToggleView: some View {
        RefdsButton {
            withAnimation { viewData.isDateFilter.toggle() }
        } label: {
            Label(
                String.localizable(by: .transactionsFilterByDate),
                systemImage: viewData.isDateFilter ? RefdsIconSymbol.checkmark.rawValue : ""
            )
        }
    }
    
    private var selectionStoriesItem: Binding<String?> {
        let items = viewData.items.map { getItemsRow(for: $0) }.flatMap { $0 }
        return Binding { items.first?.name } set: { name in
            guard let name = items.first(where: { $0.name == name })?.name else { return }
            viewData.selectedItems.remove(name)
        }
    }
    
    private func getItemsRow(for item: FilterItem) -> [FilterItemViewDataProtocol] {
        switch item {
        case .date: return []
        case .categories(let itemsRow): return itemsRow
        case .tags(let itemsRow): return itemsRow
        case .status(let itemsRow): return itemsRow
        }
    }
}

#Preview {
    struct ContainerView: View {
        @State private var viewData: FilterViewDataProtocol = FilterViewDataMock()
        
        var body: some View {
            FilterView(viewData: $viewData)
        }
    }
    return ContainerView()
}
