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
    @Environment(\.navigate) private var navigate
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
        .onChange(of: state.filter.isDateFilter) { reloadData() }
        .onChange(of: state.filter.date) { reloadData() }
        .onChange(of: state.filter.selectedItems) { reloadData() }
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
                    RefdsButton {
                        navigate?.to(
                            scene: .current,
                            view: .category,
                            viewStates: [.id(category.id)]
                        )
                    } label: {
                        CategoryRowView(viewData: category)
                    }
                    .contextMenu {
                        editCategoryButton(at: index)
                        removeCategoryButton(at: index)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        swipeRemoveButton(at: index)
                        swipeEditButton(at: index)
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
    private func editCategoryButton(at index: Int) -> some View {
        let category = state.categories[index]
        RefdsButton {
            navigate?.to(
                scene: .current,
                view: .addCategory,
                viewStates: [.id(category.id)]
            )
        } label: {
            Label(
                String.localizable(by: .categoriesEditCategory),
                systemImage: RefdsIconSymbol.squareAndPencil.rawValue
            )
        }
    }
    
    @ViewBuilder
    private func removeCategoryButton(at index: Int) -> some View {
        let category = state.categories[index]
        RefdsButton {
            action(.removeCategory(category.id))
        } label: {
            Label(
                String.localizable(by: .categoriesRemoveCategory),
                systemImage: RefdsIconSymbol.trashFill.rawValue
            )
        }
    }
    
    @ViewBuilder
    private func swipeRemoveButton(at index: Int) -> some View {
        let category = state.categories[index]
        RefdsButton {
            action(.removeCategory(category.id))
        } label: {
            RefdsIcon(.trashFill)
        }
        .tint(.red)
    }
    
    @ViewBuilder
    private func swipeEditButton(at index: Int) -> some View {
        let category = state.categories[index]
        RefdsButton {
            navigate?.to(
                scene: .current,
                view: .addCategory,
                viewStates: [.id(category.id)]
            )
        } label: {
            RefdsIcon(.squareAndPencil)
        }
        .tint(.orange)
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
            RefdsButton {
                navigate?.to(
                    scene: .current,
                    view: .addBudget,
                    viewStates: []
                )
            } label: {
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
        RefdsButton {
            navigate?.to(
                scene: .current,
                view: .addCategory,
                viewStates: []
            )
        } label: {
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
                RefdsText(
                    .localizable(by: .categoriesEmptyBudgetsDescription),
                    style: .callout
                )
                RefdsButton { 
                    navigate?.to(
                        scene: .current,
                        view: .addBudget,
                        viewStates: []
                    )
                } label: {
                    RefdsText(
                        .localizable(by: .categoriesEmptyBudgetsButton),
                        style: .callout,
                        color: .accentColor
                    )
                }
            } header: {
                RefdsText(
                    .localizable(by: .categoriesEmptyBudgetsTitle),
                    style: .footnote,
                    color: .secondary
                )
            }
        }
    }
    
    @ViewBuilder
    private var sectionEmptyCategories: some View {
        if state.isEmptyCategories {
            RefdsSection {
                RefdsText(
                    .localizable(by: .categoriesEmptyCategoriesDescription),
                    style: .callout
                )
                RefdsButton { 
                    navigate?.to(
                        scene: .current,
                        view: .addCategory,
                        viewStates: []
                    )
                } label: {
                    RefdsText(
                        .localizable(by: .categoriesEmptyCategoriesButton),
                        style: .callout,
                        color: .accentColor
                    )
                }
            } header: {
                RefdsText(
                    .localizable(by: .categoriesEmptyCategoriesTitle),
                    style: .footnote,
                    color: .secondary
                )
            }
        }
    }
    
    @ViewBuilder
    private var sectionFilters: some View {
        FilterView(viewData: $state.filter)
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
                navigate?.to(
                    scene: .current,
                    view: .addCategory,
                    viewStates: []
                )
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
