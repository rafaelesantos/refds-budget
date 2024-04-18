import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsShared
import RefdsBudgetPresentation

public struct TransactionsView: View {
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
        .navigationTitle(String.localizable(by: .transactionsMoreMenuHeader))
        .onAppear { reloadData() }
        .refreshable { reloadData() }
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
        action(.fetchData(state.isFilterEnable ? state.date : nil, state.searchText))
    }
    
    private var bindingFilterEnable: Binding<Bool> {
        Binding {
            state.isFilterEnable
        } set: { isEnable in
            withAnimation {
                state.isFilterEnable = isEnable
            }
        }
    }
    
    @ViewBuilder
    private var sectionBalance: some View {
        if let balance = state.balance {
            RefdsSection {
                BalanceRowView(viewData: balance)
                rowApplyFilter
                addTransactionButton
            } header: {
                RefdsText(.localizable(by: .categoriesBalance), style: .footnote, color: .secondary)
            }
        }
    }
    
    private var rowApplyFilter: some View {
        RefdsToggle(isOn: bindingFilterEnable) {
            RefdsText(.localizable(by: .categoriesApplyFilters), style: .callout)
        }
        .padding(.horizontal, .padding(.extraSmall))
    }
    
    @ViewBuilder
    private var sectionFilters: some View {
        if state.isFilterEnable {
            RefdsSection {
                DateRowView(date: $state.date) {
                    HStack {
                        RefdsIcon(.calendar, color: .accentColor, style: .title3)
                        RefdsText(.localizable(by: .categoriesDate), style: .callout)
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
                    style: .callout,
                    weight: .bold
                )
            }
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
                TransactionsView(state: $store.state.transactions) {
                    store.dispatch(action: $0)
                }
            }
        }
    }
    return ContainerView()
}
