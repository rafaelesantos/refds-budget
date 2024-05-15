import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsShared
import RefdsBudgetDomain
import RefdsBudgetPresentation

public struct TransactionsView: View {
    @Environment(\.privacyMode) private var privacyMode
    @Environment(\.editMode) private var editMode
    @Binding private var state: TransactionsStateProtocol
    
    @State private var multiSelection = Set<UUID>()
    @State private var privacyModeEditable = false
    
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
            SubscriptionRowView()
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
        .environment(\.privacyMode, privacyModeEditable)
        .onChange(of: state.isFilterEnable) { reloadData() }
        .onChange(of: state.date) { reloadData() }
        .onChange(of: state.searchText) { reloadData() }
        .onChange(of: state.selectedCategories) { reloadData() }
        .onChange(of: state.selectedTags) { reloadData() }
        .onChange(of: state.selectedStatus) { reloadData() }
        .toolbar {
            ToolbarItemGroup {
                moreButton
            }
        }
        .refdsDismissesKeyboad()
        .refdsToast(item: $state.error)
    }
    
    private func reloadData() {
        privacyModeEditable = privacyMode
        action(.fetchData)
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
        } resolve: { id in
            action(.updateStatus(id))
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
            
            BudgetLabel(
                title: .transactionsNewTransactions,
                icon: .plus,
                isProFeature: false
            ) {
                action(.addTransaction(nil))
            }
            
            BudgetLabel(
                title: editMode.isEditing ? .transactionsOptionsSelectDone : .transactionsOptionsSelect,
                icon: editMode.isEditing ? .circle : .checkmarkCircle,
                isProFeature: false
            ) {
                editMode?.wrappedValue.toggle()
            }
            
            if !multiSelection.isEmpty {
                BudgetLabel(
                    title: .transactionsRemoveTransactions,
                    icon: .trashFill,
                    isProFeature: false
                ) {
                    action(.removeTransactions(multiSelection))
                    if editMode.isEditing {
                        editMode?.wrappedValue.toggle()
                    }
                }
            }
            
            Divider()
            
            if !state.transactions.isEmpty {
                let ids = multiSelection.isEmpty ? Set(state.transactions.flatMap { $0 }.map { $0.id }) : multiSelection
                BudgetLabel(
                    title: .transactionsCopyTransactions,
                    icon: .docOnClipboard,
                    isProFeature: true
                ) {
                    action(.copyTransactions(ids))
                    if editMode.isEditing {
                        editMode?.wrappedValue.toggle()
                    }
                }
            }
            
            BudgetLabel(
                title: .settingsRowPrivacyMode,
                icon: privacyModeEditable ? .eyeSlashFill : .eyeFill,
                isProFeature: true
            ) {
                privacyModeEditable.toggle()
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
            selectStatusRowView
        } label: {
            HStack {
                RefdsText(.localizable(by: .categoriesFilter), style: .callout)
                Spacer()
                if state.isFilterEnable {
                    RefdsText(
                        state.date.asString(withDateFormat: .custom("MMMM, yyyy")).capitalized,
                        style: .callout,
                        color: .secondary
                    )
                }
                RefdsIcon(.chevronUpChevronDown, color: .secondary.opacity(0.5), style: .callout)
            }
        }
        
        let words = Array(state.selectedStatus) + Array(state.selectedTags) + Array(state.selectedCategories)
        let sentence = words.joined(separator: " • ").uppercased()
        
        if !sentence.isEmpty {
            HStack(spacing: .padding(.medium)) {
                RefdsText(sentence, style: .footnote, color: .secondary)
                Spacer(minLength: .zero)
                RefdsButton {
                    withAnimation {
                        state.selectedTags = []
                        state.selectedCategories = []
                        state.selectedStatus = []
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
                .buttonStyle(.plain)
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
    
    @ViewBuilder
    private var selectStatusRowView: some View{
        let status: [TransactionStatus] = [.pending, .cleared]
        SelectMenuRowView(
            header: .addTransactionStatusSelect,
            icon: .listDashHeaderRectangle,
            title: .addTransactionStatusSpend,
            data: status.map { $0.description },
            selectedData: $state.selectedStatus
        )
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
