import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsShared
import RefdsBudgetPresentation

public struct TransactionsView: View {
    @Environment(\.editMode) private var editMode
    @Binding private var state: TransactionsStateProtocol
    @State private var multiSelection = Set<UUID>()
    private let action: (TransactionsAction) -> Void
    
    public init(
        state: Binding<TransactionsStateProtocol>,
        action: @escaping (TransactionsAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    public var body: some View {
        List(selection: $multiSelection) {
            sectionBalance
            LoadingRowView(isLoading: state.isLoading)
            sectionFilters
            sectionTransactions
        }
        #if os(macOS)
        .listStyle(.plain)
        #elseif os(iOS)
        .listStyle(.insetGrouped)
        #endif
        .searchable(text: $state.searchText)
        .navigationTitle(editMode.isEditing ? String.localizable(by: .transactionEditNavigationTitle, with: multiSelection.count) : String.localizable(by: .transactionNavigationTitle))
        .onAppear { reloadData() }
        .refreshable { reloadData() }
        .onChange(of: state.isFilterEnable) { reloadData() }
        .onChange(of: state.date) { reloadData() }
        .onChange(of: state.searchText) { reloadData() }
        .onChange(of: state.selectedCategories) { reloadData() }
        .onChange(of: state.selectedTags) { reloadData() }
        .toolbar {
            ToolbarItemGroup {
                moreButton
            }
        }
        .refdsDismissesKeyboad()
        .refdsToast(item: $state.error)
    }
    
    private func reloadData() {
        action(
            .fetchData(
                state.isFilterEnable ? state.date : nil,
                state.searchText,
                state.selectedCategories,
                state.selectedTags
            )
        )
    }
    
    @ViewBuilder
    private var sectionBalance: some View {
        if let balance = state.balance {
            RefdsSection {
                BalanceRowView(viewData: balance)
                addTransactionButton
            } header: {
                RefdsText(.localizable(by: .categoriesBalance), style: .footnote, color: .secondary)
            }
        }
    }
    
    private var sectionTransactions: some View {
        TransactionSectionsView(viewData: state.transactions) {
            action(.fetchTransactionForEdit($0.id))
        } remove: { id in
            action(.removeTransaction(id))
        }
    }
    
    private var addTransactionButton: some View {
        RefdsButton { action(.addTransaction(nil)) } label: {
            HStack {
                RefdsText(
                    .localizable(by: .transactionsAddTransaction),
                    style: .callout,
                    color: .accentColor
                )
                Spacer()
                RefdsIcon(
                    .chevronRight,
                    color: .secondary.opacity(0.5),
                    style: .callout
                )
            }
        }
    }
    
    private var moreButton: some View {
        Menu {
            RefdsText(.localizable(by: .transactionsMoreMenuHeader, with: multiSelection.count))
            Divider()
            
            RefdsButton {
                withAnimation { editMode?.wrappedValue.toggle() }
            } label: {
                Label(
                    editMode.isEditing ? String.localizable(by: .transactionsOptionsSelectDone) : String.localizable(by: .transactionsOptionsSelect),
                    systemImage: RefdsIconSymbol.checkmarkCircle.rawValue
                )
            }
            
            if !multiSelection.isEmpty {
                Button(role: .destructive) {
                    action(.removeTransactions(multiSelection))
                    if editMode.isEditing { 
                        withAnimation { editMode?.wrappedValue.toggle() }
                    }
                } label: {
                    Label(
                        String.localizable(by: .transactionsRemoveTransactions),
                        systemImage: RefdsIconSymbol.trashFill.rawValue
                    )
                }
            }
            
            if !state.transactions.isEmpty {
                let ids = multiSelection.isEmpty ? Set(state.transactions.flatMap { $0 }.map { $0.id }) : multiSelection
                RefdsButton {
                    action(.copyTransactions(ids))
                    if editMode.isEditing { 
                        withAnimation { editMode?.wrappedValue.toggle() }
                    }
                } label: {
                    Label(
                        String.localizable(by: .transactionsCopyTransactions),
                        systemImage: RefdsIconSymbol.docOnClipboard.rawValue
                    )
                }
            }
            
            RefdsButton {
                action(.addTransaction(nil))
            } label: {
                Label(
                    String.localizable(by: .transactionsNewTransactions),
                    systemImage: RefdsIconSymbol.plus.rawValue
                )
            }
        } label: {
            RefdsIcon(
                .ellipsisCircleFill,
                color: .accentColor,
                size: 18,
                weight: .bold,
                renderingMode: .hierarchical
            )
        }
    }
    
    @ViewBuilder
    private var sectionFilters: some View {
        Menu {
            RefdsButton {
                withAnimation { state.isFilterEnable.toggle() }
            } label: {
                Label(
                    String.localizable(by: .transactionsFilterByDate),
                    systemImage: state.isFilterEnable ? RefdsIconSymbol.checkmark.rawValue : ""
                )
            }
            
            if state.isFilterEnable {
                DateRowView(date: $state.date, content: {})
            }
            
            selectCategoryRowView
            selectTagRowView
        } label: {
            HStack {
                RefdsText(.localizable(by: .categoriesFilter), style: .callout)
                Spacer()
                if state.isFilterEnable {
                    RefdsText(state.date.asString(withDateFormat: .custom("MMMM, yyyy")), style: .callout, color: .secondary)
                }
                RefdsIcon(.chevronUpChevronDown, color: .secondary.opacity(0.5), style: .callout)
            }
        }
        
        let words = Array(state.selectedTags) + Array(state.selectedCategories)
        let sentence = words.joined(separator: " • ").uppercased()
        
        if !sentence.isEmpty {
            HStack(spacing: .padding(.medium)) {
                RefdsText(sentence, style: .footnote, color: .secondary)
                Spacer(minLength: .zero)
                RefdsButton {
                    withAnimation {
                        state.selectedTags = []
                        state.selectedCategories = []
                    }
                } label: {
                    RefdsIcon(
                        .xmarkCircleFill,
                        color: .secondary.opacity(0.8),
                        size: 18,
                        weight: .bold,
                        renderingMode: .hierarchical
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    private var selectCategoryRowView: some View {
        if !state.categories.isEmpty {
            SelectMenuRowView(
                header: .transactionsCategoriesFilterHeader,
                icon: .squareStack3dForwardDottedlineFill,
                title: .categoriesNavigationTitle,
                data: state.categories,
                selectedData: $state.selectedCategories
            )
        }
    }
    
    @ViewBuilder
    private var selectTagRowView: some View {
        if !state.tags.isEmpty {
            SelectMenuRowView(
                header: .tagsMenuSelectHeader,
                icon: .tagFill,
                title: .tagsNavigationTitle,
                data: state.tags,
                selectedData: $state.selectedTags
            )
        }
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = RefdsReduxStoreFactory(mock: true).mock
        
        var body: some View {
            NavigationStack {
                TransactionsView(state: $store.state.transactionsState) {
                    store.dispatch(action: $0)
                }
            }
        }
    }
    return ContainerView()
}
