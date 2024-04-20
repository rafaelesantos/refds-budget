import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsShared
import RefdsBudgetPresentation

public struct CategoryView: View {
    @Binding private var state: CategoryStateProtocol
    @State private var multiSelection = Set<UUID>()
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
        .onChange(of: state.isFilterEnable) { reloadData() }
        .onChange(of: state.date) { reloadData() }
        .onChange(of: state.searchText) { reloadData() }
        .toolbar {
            ToolbarItemGroup {
                #if os(macOS)
                #else
                EditButton()
                #endif
                moreButton
            }
        }
        .refdsDismissesKeyboad()
        .refdsToast(item: $state.error)
    }
    
    private func reloadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            action(.fetchData(state.isFilterEnable ? state.date : nil, state.id, state.searchText))
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
    
    private var rowApplyFilter: some View {
        RefdsToggle(isOn: $state.isFilterEnable) {
            RefdsText(.localizable(by: .categoriesApplyFilters), style: .callout)
        }
    }
    
    private var sectionFilters: some View {
        RefdsSection {
            rowApplyFilter
            if state.isFilterEnable {
                DateRowView(date: $state.date) {
                    HStack {
                        RefdsIconRow(.calendar)
                        RefdsText(.localizable(by: .categoriesDate), style: .callout)
                    }
                }
            }
        } header: {
            RefdsText(
                .localizable(by: .categoriesFilter),
                style: .footnote,
                color: .secondary
            )
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
            RefdsSection {
                let data: [(x: String, y: Double, percentage: Double?)] = state.budgtes.map {
                    (
                        x: $0.date.asString(withDateFormat: .monthYear),
                        y: $0.amount,
                        percentage: $0.percentage
                    )
                }
                DateChartView(data: data)
            } header: {
                RefdsText(
                    .localizable(by: .categoriesChartHeader),
                    style: .footnote,
                    color: .secondary
                )
            }
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
        }
    }
    
    private var moreButton: some View {
        Menu {
            if !multiSelection.isEmpty {
                RefdsText(.localizable(by: .transactionsMoreMultiMenuHeader, with: multiSelection.count))
                Divider()
                RefdsButton {
                    action(.removeTransactions(multiSelection))
                } label: {
                    Label(
                        String.localizable(by: .transactionsRemoveTransactions),
                        systemImage: RefdsIconSymbol.trashFill.rawValue
                    )
                }
            } else {
                RefdsText(.localizable(by: .transactionsMoreMenuHeader, with: multiSelection.count))
                Divider()
            }
            
            if !state.transactions.isEmpty {
                let ids = multiSelection.isEmpty ? Set(state.transactions.flatMap { $0 }.map { $0.id }) : multiSelection
                RefdsButton {
                    action(.copyTransactions(ids))
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
