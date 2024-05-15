import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetDomain
import RefdsBudgetPresentation

public struct HomeView: View {
    @Environment(\.privacyMode) private var privacyMode
    @Binding private var state: HomeStateProtocol
    @State private var privacyModeEditable = false
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
            SubscriptionRowView()
            balanceSectionView
            LoadingRowView(isLoading: state.isLoading)
            sectionFilters
            emptyBudgetView
            spendBudgetSectionView
            largestPurchaseSectionView
            remainingSectionView
            pendingClearedSectionView
            tagsSectionView
        }
        .navigationTitle(String.localizable(by: .homeNavigationTitle))
        .toolbar { ToolbarItem { moreButton } }
        .onAppear { reloadData() }
        .refreshable { reloadData() }
        .onChange(of: state.isFilterEnable) { reloadData() }
        .onChange(of: state.date) { reloadData() }
        .onChange(of: state.selectedTags) { reloadData() }
        .onChange(of: state.selectedCategories) { reloadData() }
        .onChange(of: state.selectedStatus) { reloadData() }
        .environment(\.privacyMode, privacyModeEditable)
        .refdsToast(item: $state.error)
    }
    
    private func reloadData() {
        privacyModeEditable = privacyMode
        action(.fetchData)
    }
    
    @ViewBuilder
    private var balanceSectionView: some View {
        if let balance = state.balance {
            RefdsSection {
                BalanceRowView(viewData: balance)
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
                icon: .bookmarkFill,
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
    
    @ViewBuilder
    private var spendBudgetSectionView: some View {
        if !state.remaining.isEmpty {
            SpendBudgetSectionView(viewData: state.remaining)
        }
    }
    
    @ViewBuilder
    private var remainingSectionView: some View {
        if let balance = state.remainingBalance {
            RemainingCategorySectionView(
                header: { BalanceRowView(viewData: balance, isRemaining: true) },
                viewData: state.remaining
            )
        }
    }
    
    @ViewBuilder
    private var tagsSectionView: some View {
        if !state.tagsRow.isEmpty {
            TagsSectionView(tags: state.tagsRow) {
                action(.manageTags)
            }
        }
    }
    
    @ViewBuilder
    private var pendingClearedSectionView: some View {
        if let pendingCleared = state.pendingCleared {
            PendingClearedSectionView(viewData: pendingCleared)
        }
    }
    
    @ViewBuilder
    private var largestPurchaseSectionView: some View {
        if !state.largestPurchase.isEmpty {
            LargestPurchaseSectionView(transactions: state.largestPurchase)
        }
    }
    
    @ViewBuilder
    private var emptyBudgetView: some View {
        if state.remaining.isEmpty, state.largestPurchase.isEmpty {
            RefdsSection {
                EmptyRowView(title: .emptyBudgetsTitle)
            } header: {
                RefdsText(
                    .localizable(by: .categoryBudgetsHeader),
                    style: .footnote,
                    color: .secondary
                )
            }
        }
    }
    
    private var moreButton: some View {
        Menu {
            RefdsText(.localizable(by: .transactionsMoreMenuHeader))
            
            Divider()
            
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
                HomeView(state: $store.state.homeState) {
                    store.dispatch(action: $0)
                }
            }
        }
    }
    return ContainerView()
}
