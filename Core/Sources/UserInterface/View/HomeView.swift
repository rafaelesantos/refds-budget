import SwiftUI
import RefdsUI
import RefdsShared
import RefdsGamification
import Domain
import Presentation

public struct HomeView: View {
    @Environment(\.privacyMode) private var privacyMode
    @Environment(\.navigate) private var navigate
    
    @State private var privacyModeEditable = false
    
    @Binding private var state: HomeStateProtocol
    private let action: (HomeAction) -> Void
    
    public init(
        state: Binding<HomeStateProtocol>,
        action: @escaping (HomeAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    public var body: some View {
        List {
            sectionBalanceView
            sectionFiltersView
            sectionSpendBudgetView
            sectionComparisonBudgetView
            sectionLargestPurchaseView
            sectionRemainingView
            sectionPendingClearedView
            sectionTagsView
        }
        .navigationTitle(String.localizable(by: .homeNavigationTitle))
        .toolbar { ToolbarItem { moreButton } }
        .onAppear { reloadData() }
        .refreshable { reloadData() }
        .onChange(of: state.filter.isDateFilter) { reloadData() }
        .onChange(of: state.filter.date) { reloadData() }
        .onChange(of: state.filter.selectedItems) { reloadData() }
        .onChange(of: state.selectedTag?.name) { showTransaction(for: state.selectedTag?.name) }
        .onChange(of: state.selectedRemaining?.name) { showTransaction(for: state.selectedRemaining?.name) }
        .environment(\.privacyMode, privacyModeEditable)
        .refdsToast(item: $state.error)
    }
    
    private func reloadData() {
        privacyModeEditable = privacyMode
        action(.fetchData)
    }
    
    private func showTransaction(for item: String?) {
        guard let item = item else { return }
        navigate?.to(
            scene: .transactions,
            view: .none,
            viewStates: [
                .isDateFilter(state.filter.isDateFilter),
                .date(state.filter.date),
                .selectedItems(Set([item]))
            ]
        )
    }
    
    private var sectionComparisonBudgetView: some View {
        ComparisonBudgetView() { hasAI in
            navigate?.to(
                scene: .current,
                view: .budgetSelection,
                viewStates: [.hasAI(hasAI)]
            )
        }
    }
    
    @ViewBuilder
    private var sectionBalanceView: some View {
        if let balance = state.balance {
            RefdsSection {
                BalanceView(viewData: balance)
            } header: {
                RefdsText(
                    .localizable(by: .categoriesBalance),
                    style: .footnote,
                    color: .secondary
                )
            }
        }
    }
    
    @ViewBuilder
    private var sectionFiltersView: some View {
        FilterView(viewData: $state.filter)
    }
    
    @ViewBuilder
    private var sectionSpendBudgetView: some View {
        if !state.remaining.isEmpty {
            SpendBudgetSectionView(viewData: state.remaining)
        }
    }
    
    @ViewBuilder
    private var sectionRemainingView: some View {
        if let balance = state.remainingBalance {
            RemainingCategorySectionView(
                header: { BalanceView(viewData: balance, isRemaining: true) },
                selectedRemaining: $state.selectedRemaining,
                viewData: state.remaining
            )
        }
    }
    
    @ViewBuilder
    private var sectionTagsView: some View {
        if !state.tagsRow.isEmpty {
            TagsSectionView(
                selectedTag: $state.selectedTag,
                tags: state.tagsRow
            ) {
                navigate?.to(
                    scene: .current,
                    view: .manageTags,
                    viewStates: []
                )
            }
        }
    }
    
    @ViewBuilder
    private var sectionPendingClearedView: some View {
        if let pendingCleared = state.pendingCleared,
           pendingCleared.pendingCount > 0 || pendingCleared.clearedCount > 0 {
            PendingClearedView(viewData: pendingCleared)
        }
    }
    
    @ViewBuilder
    private var sectionLargestPurchaseView: some View {
        if !state.largestPurchase.isEmpty {
            LargestPurchaseSectionView(transactions: state.largestPurchase)
        }
    }

    private var moreButton: some View {
        Menu {
            RefdsText(.localizable(by: .transactionsMoreMenuHeader))
            
            Divider()
            
            BudgetLabel(
                title: .settingsRowPrivacyMode,
                icon: privacyModeEditable ? .eyeSlashFill : .eyeFill
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
        @StateObject private var store = StoreFactory.development
        
        var body: some View {
            NavigationStack {
                HomeView(state: $store.state.homeState) {
                    store.dispatch(action: $0)
                }
            }
        }
    }
    return ContainerView()
}
