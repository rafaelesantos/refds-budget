import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsShared
import RefdsBudgetPresentation

public struct CategoryView: View {
    @Environment(\.privacyMode) private var privacyMode
    @Environment(\.editMode) private var editMode
    @Binding private var state: CategoryStateProtocol
    @State private var multiSelection = Set<UUID>()
    @State private var privacyModeEditable = false
    private let action: (CategoryAction) -> Void
    
    public init(
        state: Binding<CategoryStateProtocol>,
        action: @escaping (CategoryAction) -> Void
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
            sectionBudgets
            sectionBudgetsChart
            sectionTransactions
        }
        #if os(macOS)
        .listStyle(.plain)
        #elseif os(iOS)
        .listStyle(.insetGrouped)
        #endif
        .searchable(text: $state.searchText)
        .navigationTitle(state.name.capitalized)
        .onAppear { reloadData() }
        .environment(\.privacyMode, privacyModeEditable)
        .onChange(of: state.isFilterEnable) { reloadData() }
        .onChange(of: state.date) { reloadData() }
        .onChange(of: state.searchText) { reloadData() }
        .toolbar { ToolbarItemGroup { moreButton } }
        .refdsDismissesKeyboad()
        .refdsToast(item: $state.error)
    }
    
    private func reloadData() {
        privacyModeEditable = privacyMode
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            action(.fetchData)
        }
    }
    
    @ViewBuilder
    private var sectionBalance: some View {
        if let balance = state.balance {
            RefdsSection {
                BalanceRowView(viewData: balance)
                editCategoryButton
                removeCategoryButton
            } header: {
                RefdsText(.localizable(by: .categoriesBalance), style: .footnote, color: .secondary)
            }
        }
    }
    
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
    }
    
    private var sectionBudgets: some View {
        RefdsSection {
            if state.budgtes.isEmpty {
                EmptyRowView(title: .emptyBudgetsTitle)
            } else {
                let budgtes = Array(state.budgtes.reversed())
                ForEach(budgtes.indices, id: \.self) { index in
                    let budget = budgtes[index]
                    BudgetRowView(viewData: budget)
                        .onTapGesture {
                            action(
                                .fetchBudgetForEdit(
                                    state.date,
                                    state.id,
                                    budget.id
                                )
                            )
                        }
                        .contextMenu {
                            removeBudgetButton(at: index)
                        }
                }
            }
        } header: {
            RefdsText(
                .localizable(by: .categoryBudgetsHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    @ViewBuilder
    private var sectionBudgetsChart: some View {
        if state.budgtes.count > 1 {
            let data: [(x: Date, y: Double, percentage: Double?)] = state.budgtes.map {
                (
                    x: $0.date,
                    y: $0.amount,
                    percentage: $0.percentage
                )
            }
            DateChartView(data: data)
        }
    }
    
    @ViewBuilder
    private func removeBudgetButton(at index: Int) -> some View {
        let budget = state.budgtes[index]
        RefdsButton {
            action(.removeBudget(state.date, budget.id))
        } label: {
            RefdsText(.localizable(by: .categoriesRemoveBudget))
        }
    }
    
    private var removeCategoryButton: some View {
        RefdsButton {
            action(.removeCategory(state.isFilterEnable ? state.date : nil, state.id))
        } label: {
            HStack {
                RefdsText(.localizable(by: .categoriesRemoveCategory), style: .callout, color: .red)
                Spacer()
            }
        }
    }
    
    private var editCategoryButton: some View {
        RefdsButton {
            action(.fetchCategoryForEdit(state.id))
        } label: {
            HStack {
                RefdsText(.localizable(by: .categoriesEditCategory), style: .callout, color: .accentColor)
                Spacer()
                RefdsIcon(.chevronRight, color: .secondary.opacity(0.5), style: .callout)
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
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = RefdsReduxStoreFactory(mock: true).mock
        
        var body: some View {
            NavigationStack {
                CategoryView(state: $store.state.categoryState) {
                    store.dispatch(action: $0)
                }
            }
        }
    }
    return ContainerView()
}
