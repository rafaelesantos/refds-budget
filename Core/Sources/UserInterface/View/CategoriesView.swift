import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsRouter
import RefdsShared
import RefdsInjection
import Domain
import Resource
import Presentation

public struct CategoriesView: View {
    @Environment(\.navigate) private var navigate
    
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
            sectionsCategory
            sectionAddBudget
        }
        .navigationTitle(String.localizable(by: .categoriesNavigationTitle))
        .onChange(of: state.filter.isDateFilter) { reloadData() }
        .onChange(of: state.filter.date) { reloadData() }
        .onChange(of: state.filter.selectedItems) { reloadData() }
        .toolbar { ToolbarItem { addCategoryButton } }
        .refreshable { reloadData() }
        .onAppear { reloadData(isOnAppear: true) }
        .refdsToast(item: $state.error)
        .refdsLoading(state.isLoading && state.categories.isEmpty)
    }
    
    private func reloadData(isOnAppear: Bool = false) {
        if isOnAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                action(.fetchData)
            }
        } else {
            action(.fetchData)
        }
    }
    
    private var addCategoryButton: some View {
        RefdsButton {
            navigate?.to(
                scene: .current,
                view: .addCategory,
                viewStates: []
            )
        } label: {
            RefdsIcon(
                .plusCircleFill,
                color: .accentColor,
                size: 18,
                weight: .bold,
                renderingMode: .hierarchical
            )
        }
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
                        CategoryItemView(viewData: category)
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
                BalanceView(viewData: balance)
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
    private var sectionAddBudget: some View {
        if !state.categoriesWithoutBudget.isEmpty {
            RefdsSection {
                RefdsText(
                    .localizable(by: .categoriesWithoutBudgetDescription),
                    style: .callout
                )
            } header: {
                RefdsText(
                    .localizable(by: .categoriesWithoutBudgetHeader),
                    style: .footnote,
                    color: .secondary
                )
            } footer: {
                ScrollView(.horizontal) {
                    HStack(spacing: .extraSmall) {
                        ForEach(state.categoriesWithoutBudget.indices, id: \.self) {
                            let category = state.categoriesWithoutBudget[$0]
                            RefdsStoryItem(
                                icon: RefdsIconSymbol(rawValue: category.icon) ?? .dollarsign,
                                color: category.color,
                                name: category.name,
                                size: 45,
                                isSelected: true
                            ) { name in
                                navigate?.to(
                                    scene: .current,
                                    view: .addBudget,
                                    viewStates: [.date(state.filter.date), .selectedItems(Set([name]))]
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .scrollIndicators(.never)
                .padding(.horizontal, -40)
            }
        }
    }
    
    @ViewBuilder
    private var sectionEmptyCategories: some View {
        if state.isEmptyCategories, !state.isLoading {
            RefdsSection {
                EmptyCategoriesView()
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
        if !(state.isLoading && state.isEmptyCategories) {
            FilterView(viewData: $state.filter)
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
                    viewFactory.makeCategoriesView(
                        state: $store.state.categoriesState,
                        action: store.dispatch(action:)
                    )
                )
            }
        }
    }
    return ContainerView()
}
