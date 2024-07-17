import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsRouter
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource
import RefdsBudgetPresentation

public struct CategoriesView: View {
    @Environment(\.privacyMode) private var privacyMode
    @Binding private var state: CategoriesStateProtocol
    @State private var privacyModeEditable = false
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
            SubscriptionRowView()
            sectionBalance
            sectionFilters
            sectionEmptyCategories
            sectionEmptyBudgets
            sectionsCategory
        }
        .navigationTitle(String.localizable(by: .categoriesNavigationTitle))
        .onChange(of: state.isFilterEnable) { reloadData() }
        .onChange(of: state.date) { reloadData() }
        .onChange(of: state.selectedTags) { reloadData() }
        .onChange(of: state.selectedStatus) { reloadData() }
        .toolbar { ToolbarItem { moreButton } }
        .environment(\.privacyMode, privacyModeEditable)
        .refreshable { reloadData() }
        .onAppear { reloadData() }
        .refdsToast(item: $state.error)
    }
    
    private func reloadData() {
        privacyModeEditable = privacyMode
        action(.fetchData)
    }
    
    @ViewBuilder
    private var sectionsCategory: some View {
        if !state.categories.isEmpty {
            RefdsSection {
                ForEach(state.categories.indices, id: \.self) { index in
                    let category = state.categories[index]
                    CategoryRowView(viewData: category)
                        .onTapGesture {
                            action(.showCategory(category.categoryId, state.isFilterEnable ? state.date : nil))
                        }
                        .contextMenu {
                            editBudgetButton(at: index)
                            editCategoryButton(at: index)
                            Divider()
                            removeBudgetButton(at: index)
                            removeCategoryButton(at: index)
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
                rowAddCategory
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
                        style: .callout
                    )
                }
            }
        }
    }
    
    private var rowAddCategory: some View {
        RefdsButton { action(.addCategory(nil)) } label: {
            HStack {
                RefdsText(
                    .localizable(by: .categoriesEmptyCategoriesButton),
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
        Menu {
            RefdsButton {
                withAnimation { state.isFilterEnable.toggle() }
            } label: {
                Label(
                    String.localizable(by: .transactionsFilterByDate),
                    systemImage: state.isFilterEnable ? RefdsIconSymbol.checkmark.rawValue : ""
                )
            }
            selectTagRowView
            selectStatusRowView
        } label: {
            HStack {
                RefdsText(.localizable(by: .categoriesFilter), style: .callout)
                Spacer()
                RefdsText(2.asString, style: .callout, color: .secondary)
                RefdsIcon(.chevronUpChevronDown, color: .secondary.opacity(0.5), style: .callout)
            }
        }
        
        if state.isFilterEnable {
            DateRowView(date: $state.date)
        }
        
        let words = Array(state.selectedTags) + Array(state.selectedStatus)
        let sentence = words.joined(separator: " • ").uppercased()
        
        if !sentence.isEmpty {
            HStack(spacing: .padding(.medium)) {
                RefdsText(sentence, style: .footnote, color: .secondary)
                Spacer(minLength: .zero)
                RefdsButton {
                    withAnimation {
                        state.selectedTags = []
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
            title: .addTransactionStatusHeader,
            data: status.map { $0.description },
            selectedData: $state.selectedStatus
        )
    }
    
    private var moreButton: some View {
        Menu {
            RefdsText(.localizable(by: .transactionsMoreMenuHeader))
            
            Divider()
            
            BudgetLabel(
                title: .categoriesEmptyCategoriesButton,
                icon: .plus,
                isProFeature: false
            ) {
                action(.addCategory(nil))
            }
            
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
        @StateObject private var store = StoreFactory.development
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
                router: $store.state.categoriesRouter,
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
