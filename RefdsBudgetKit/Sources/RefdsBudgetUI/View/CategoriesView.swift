import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsRouter
import RefdsInjection
import RefdsBudgetResource
import RefdsBudgetPresentation

public struct CategoriesView: View {
    @Binding private var state: CategoriesStateProtocol
    private let action: (CategoriesAction) -> Void
    
    public init(
        state: Binding<CategoriesStateProtocol>,
        action: @escaping (CategoriesAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    public var body: some View {
        List {
            sectionBalance
            sectionFilters
            sectionEmptyCategories
            sectionEmptyBudgets
            sectionsCategory
            sectionBudgetsChart
            sectionLegend
        }
        #if os(macOS)
        .listStyle(.plain)
        #elseif os(iOS)
        .listStyle(.insetGrouped)
        #endif
        .navigationTitle(String.localizable(by: .categoriesNavigationTitle))
        .onChange(of: state.isFilterEnable) { reloadData() }
        .onChange(of: state.date) { reloadData() }
        .toolbar { ToolbarItem { addCategoryButton } }
        .refreshable { reloadData() }
        .onAppear { reloadData() }
        .refdsToast(item: $state.error)
    }
    
    private func reloadData() {
        action(.fetchData(state.isFilterEnable ? state.date : nil))
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
    
    private var bindingDate: Binding<Date> {
        Binding {
            state.date
        } set: {
            state.date = $0
            action(.fetchData(state.date))
        }
    }
    
    private var sectionsCategory: some View {
        ForEach(state.categories.indices, id: \.self) { index in
            let category = state.categories[index]
            CategoryRowView(viewData: category)
                .onTapGesture {
                    action(.showCategory(category.categoryId))
                }
                .contextMenu {
                    editBudgetButton(at: index)
                    editCategoryButton(at: index)
                    Divider()
                    removeBudgetButton(at: index)
                    removeCategoryButton(at: index)
                }
        }
    }
    
    @ViewBuilder
    private func editBudgetButton(at index: Int) -> some View {
        if state.isFilterEnable {
            let category = state.categories[index]
            RefdsButton {
                action(
                    .fetchBudgetForEdit(
                        state.date,
                        category.categoryId,
                        category.budgetId
                    )
                )
            } label: {
                RefdsText(.localizable(by: .categoriesEditBudget))
            }
        }
    }
    
    @ViewBuilder
    private func editCategoryButton(at index: Int) -> some View {
        let category = state.categories[index]
        RefdsButton {
            action(.fetchCategoryForEdit(category.categoryId))
        } label: {
            RefdsText(.localizable(by: .categoriesEditCategory))
        }
    }
    
    @ViewBuilder
    private func removeBudgetButton(at index: Int) -> some View {
        if state.isFilterEnable {
            let category = state.categories[index]
            RefdsButton {
                action(.removeBudget(state.date, category.budgetId))
            } label: {
                RefdsText(.localizable(by: .categoriesRemoveBudget))
            }
        }
    }
    
    @ViewBuilder
    private func removeCategoryButton(at index: Int) -> some View {
        let category = state.categories[index]
        RefdsButton {
            action(.removeCategory(state.isFilterEnable ? state.date : nil, category.categoryId))
        } label: {
            RefdsText(.localizable(by: .categoriesRemoveCategory))
        }
    }
    
    @ViewBuilder
    private var sectionBalance: some View {
        if let balance = state.balance {
            RefdsSection {
                BalanceRowView(viewData: balance)
                rowApplyFilter
                rowAddBudget
            } header: {
                RefdsText(
                    .localizable(
                        by: .categoriesBalance
                    ),
                    style: .footnote,
                    color: .secondary
                )
            }
        }
    }
    
    @ViewBuilder
    private var rowAddBudget: some View {
        if !state.isEmptyCategories, !state.isEmptyBudgets {
            RefdsButton { action(.addBudget(nil, state.date)) } label: {
                HStack {
                    RefdsText(
                        .localizable(by: .categoriesEmptyBudgetsButton),
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
    }
    
    private var rowApplyFilter: some View {
        RefdsToggle(isOn: bindingFilterEnable) {
            RefdsText(.localizable(by: .categoriesApplyFilters), style: .callout)
        }
    }
    
    @ViewBuilder
    private var sectionEmptyBudgets: some View {
        if !state.isEmptyCategories, state.isEmptyBudgets {
            RefdsSection {
                RefdsText(.localizable(by: .categoriesEmptyBudgetsDescription), style: .callout)
                RefdsButton { action(.addBudget(nil, state.date)) } label: {
                    RefdsText(.localizable(by: .categoriesEmptyBudgetsButton), style: .callout, color: .accentColor)
                }
            } header: {
                RefdsText(.localizable(by: .categoriesEmptyBudgetsTitle), style: .footnote, color: .secondary)
            }
        }
    }
    
    @ViewBuilder
    private var sectionEmptyCategories: some View {
        if state.isEmptyCategories {
            RefdsSection {
                RefdsText(.localizable(by: .categoriesEmptyCategoriesDescription), style: .callout)
                RefdsButton { action(.addCategory(nil)) } label: {
                    RefdsText(.localizable(by: .categoriesEmptyCategoriesButton), style: .callout, color: .accentColor)
                }
            } header: {
                RefdsText(.localizable(by: .categoriesEmptyCategoriesTitle), style: .footnote, color: .secondary)
            }
        }
    }
    
    @ViewBuilder
    private var sectionFilters: some View {
        if state.isFilterEnable {
            RefdsSection {
                DateRowView(date: $state.date) {
                    HStack(spacing: .padding(.medium)) {
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
    
    private var addCategoryButton: some View {
        RefdsIcon(
            .plusCircleFill,
            color: .accentColor,
            size: 18,
            weight: .bold,
            renderingMode: .hierarchical
        )
        .onTapGesture {
            action(.addCategory(nil))
        }
    }
    
    @ViewBuilder
    private var sectionBudgetsChart: some View {
        if !state.isEmptyCategories, !state.isEmptyBudgets {
            RefdsSection {
                let data: [(x: String, y: Double, percentage: Double?)] = state.categories.map {
                    (
                        x: $0.name,
                        y: $0.budget,
                        percentage: $0.percentage
                    )
                }
                DateChartView(data: data, isScrollable: false)
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
    private var sectionLegend: some View {
        if !state.isEmptyBudgets {
            RefdsSection {
                rowLegend(
                    title: .localizable(by: .categoriesGreenLegendTitle),
                    description: .localizable(by: .categoriesGreenLegendDescription),
                    color: .green
                )
                rowLegend(
                    title: .localizable(by: .categoriesYellowLegendTitle),
                    description: .localizable(by: .categoriesYellowLegendDescription),
                    color: .yellow
                )
                rowLegend(
                    title: .localizable(by: .categoriesOrangeLegendTitle),
                    description: .localizable(by: .categoriesOrangeLegendDescription),
                    color: .orange
                )
                rowLegend(
                    title: .localizable(by: .categoriesRedLegendTitle),
                    description: .localizable(by: .categoriesRedLegendDescription),
                    color: .red
                )
            } header: {
                RefdsText(
                    .localizable(by: .categoriesLegend),
                    style: .footnote,
                    color: .secondary
                )
            }
        }
    }
    
    private func rowLegend(
        title: String,
        description: String,
        color: Color
    ) -> some View {
        HStack(spacing: .padding(.medium)) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 20, height: 20)
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 10, height: 10)
            }
            
            VStack(alignment: .leading) {
                RefdsText(title, style: .callout)
                RefdsText(description, style: .footnote, color: .secondary)
            }
        }
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = RefdsReduxStoreFactory(mock: true).mock
        private var viewFactory = ViewFactory()
        
        init() {
            RefdsContainer.register(type: ViewFactoryProtocol.self) { viewFactory }
        }
        
        private var bindingState: Binding<RefdsReduxState> {
            Binding {
                store.state
            } set: {
                guard let state = $0 as? ApplicationStateProtocol else { return }
                store.state = state
            }
        }
        
        var body: some View {
            RefdsRoutingReduxView(
                router: $store.state.router,
                state: bindingState,
                action: store.dispatch(action:)
            ) {
                AnyView(
                    viewFactory.makeCegoriesView(
                        state: $store.state.categoriesState,
                        action: store.dispatch(action:)
                    )
                )
            }
        }
    }
    return ContainerView()
}