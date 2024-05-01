import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct HomeView: View {
    @Binding private var state: HomeStateProtocol
    private let action: (HomeAction) -> Void
    
    public init(
        state: Binding<HomeStateProtocol>,
        action: @escaping (HomeAction) -> Void
    ) {
        self._state = state
        self.action = action
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
    
    public var body: some View {
        List {
            balanceSectionView
            LoadingRowView(isLoading: state.isLoading)
            sectionFilters
            emptyBudgetView
            spendBudgetSectionView
            remainingSectionView
            tagsSectionView
            largestPurchaseSectionView
        }
        .navigationTitle(String.localizable(by: .homeNavigationTitle))
        .onAppear { reloadData() }
        .refreshable { reloadData() }
        .onChange(of: state.isFilterEnable) { reloadData() }
        .onChange(of: state.date) { reloadData() }
        .onChange(of: state.selectedTags) { reloadData() }
        .onChange(of: state.selectedCategories) { reloadData() }
        .refdsToast(item: $state.error)
    }
    
    private func reloadData() {
        action(.fetchData(state.isFilterEnable ? state.date : nil))
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
    
    private var sectionFilters: some View {
        RefdsSection {
            rowApplyFilter
            if state.isFilterEnable {
                DateRowView(date: $state.date) {
                    HStack(spacing: .padding(.medium)) {
                        RefdsIconRow(.calendar)
                        RefdsText(.localizable(by: .categoriesDate), style: .callout)
                    }
                }
            }
            selectCategoryRowView
            selectTagRowView
        } header: {
            RefdsText(
                .localizable(by: .categoriesFilter),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var rowApplyFilter: some View {
        RefdsToggle(isOn: bindingFilterEnable) {
            RefdsText(.localizable(by: .transactionsFilterByDate), style: .callout)
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
