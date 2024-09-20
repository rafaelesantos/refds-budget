import SwiftUI
import RefdsUI
import RefdsShared
import Mock
import Domain
import Presentation

public struct CategoryView: View {
    @Environment(\.privacyMode) private var privacyMode
    @Environment(\.navigate) private var navigate
    
    @Binding private var state: CategoryStateProtocol
    private let action: (CategoryAction) -> Void
    
    public init(
        state: Binding<CategoryStateProtocol>,
        action: @escaping (CategoryAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    public var body: some View {
        List {
            sectionCurrency
            sectionBudgets
            sectionTransactions
        }
        .if(state.category) { view, category in
            view
                .navigationTitle(category.name.capitalized)
        }
        .onAppear { reloadData() }
        .onChange(of: state.filter.currentPage) { reloadData() }
        .toolbar { ToolbarItem(placement: .bottomBar) { paginationView } }
        .refdsToast(item: $state.error)
        .refdsLoading(state.isLoading)
    }
    
    private func reloadData() {
        action(.fetchData)
    }
    
    @ViewBuilder
    private var iconNavigationHeader: some View {
        if let category = state.category,
           let icon = RefdsIconSymbol(rawValue: category.icon) {
            RefdsIconRow(
                icon,
                color: category.color,
                size: 35
            )
            .padding(.trailing, -5)
        }
    }
    
    @ViewBuilder
    private var sectionCurrency: some View {
        if let category = state.category {
            RefdsSection {
                ZStack(alignment: .topTrailing) {
                    VStack(spacing: .padding(.small)) {
                        VStack(spacing: .zero) {
                            RefdsText(
                                category.budget.currency(),
                                style: .largeTitle,
                                weight: .bold
                            )
                            .refdsRedacted(if: privacyMode)
                            
                            RefdsText(
                                category.spend.currency(),
                                style: .title3,
                                color: .secondary
                            )
                            .refdsRedacted(if: privacyMode)
                            
                            RefdsScaleProgressView(
                                .circle,
                                riskColor: category.percentage.riskColor,
                                size: 35
                            )
                            .padding(.vertical, 5)
                            .padding(.top, 5)
                        }
                        
                        if let description = state.description {
                            Divider()
                            
                            RefdsText(
                                description,
                                style: .callout,
                                color: .secondary,
                                alignment: .center
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                    iconNavigationHeader
                }
            } header: {
                RefdsText(
                    .localizable(by: .categoriesBalance),
                    style: .footnote,
                    color: .secondary
                )
            } footer: {
                HStack {
                    addBudgetButton
                    Spacer()
                    editCategoryButton
                    Spacer()
                    removeCategoryButton
                }
                .padding(.top, 10)
                .padding(.bottom, -15)
            }
        }
    }
    
    @ViewBuilder
    private var sectionBudgets: some View {
        if !state.budgets.isEmpty {
            RefdsSection {
                ForEach(state.budgets.indices, id: \.self) { index in
                    let budget = state.budgets[index]
                    RefdsButton {
                        navigate?.to(
                            scene: .current,
                            view: .addBudget,
                            viewStates: [.id(budget.id)]
                        )
                    } label: {
                        BudgetItemView(viewData: budget)
                    }
                    .contextMenu {
                        contextRemoveBudget(by: budget.id)
                    }
                    .swipeActions {
                        swipeRemoveBudget(by: budget.id)
                    }
                }
            } header: {
                RefdsText(
                    .localizable(by: .categoryBudgetsHeader),
                    style: .footnote,
                    color: .secondary
                )
            }
            .transaction(value: state.budgets.isEmpty, { $0.animation = .easeInOut })
        }
    }
    
    @ViewBuilder
    private var sectionTransactions: some View {
        if let category = state.category, category.spend > .zero {
            RefdsSection {
                RefdsButton {
                    navigate?.to(
                        scene: .transactions,
                        view: .none,
                        viewStates: [
                            .isDateFilter(true),
                            .date(.now),
                            .selectedItems(Set([category.name]))
                        ]
                    )
                } label: {
                    HStack(spacing: .padding(.medium)) {
                        RefdsIconRow(
                            .listBulletRectangleFill,
                            color: category.color
                        )
                        
                        RefdsText(.localizable(by: .itemNavigationTransactions))
                        
                        Spacer()
                        
                        RefdsIcon(
                            .chevronRight,
                            color: .secondary.opacity(0.5),
                            style: .callout
                        )
                    }
                }
            } header: {
                RefdsText(
                    .localizable(by: .transactionsMoreMenuHeader),
                    style: .footnote,
                    color: .secondary
                )
            }
        }
    }
    
    private func contextRemoveBudget(by id: UUID) -> some View {
        RefdsButton {
            action(.removeBudget(id))
        } label: {
            RefdsText(.localizable(by: .categoriesRemoveBudget))
        }
    }
    
    private func swipeRemoveBudget(by id: UUID) -> some View {
        RefdsButton {
            action(.removeBudget(id))
        } label: {
            RefdsIcon(.trashFill)
        }
        .tint(.red)
    }
    
    @ViewBuilder
    private var removeCategoryButton: some View {
        if let id = state.id {
            RefdsStoryItem(
                icon: .trashFill,
                color: state.category?.color ?? .red,
                name: .localizable(by: .addBudgetCategoryHeader),
                isSelected: true,
                showName: false
            ){ _ in
                action(.removeCategory(id))
            }
        }
    }
    
    @ViewBuilder
    private var editCategoryButton: some View {
        if let id = state.id {
            RefdsStoryItem(
                icon: .squareAndPencil,
                color: state.category?.color ?? .orange,
                name: .localizable(by: .addBudgetCategoryHeader),
                isSelected: true,
                showName: false
            ) { _ in
                navigate?.to(
                    scene: .current,
                    view: .addCategory,
                    viewStates: [.id(id)]
                )
            }
        }
    }
    
    @ViewBuilder
    private var addBudgetButton: some View {
        if let category = state.category {
            RefdsStoryItem(
                icon: .plus,
                color: state.category?.color ?? .accentColor,
                name: .localizable(by: .categoriesBalanceSubtitle),
                isSelected: true,
                showName: false
            ) { _ in
                navigate?.to(
                    scene: .current,
                    view: .addBudget,
                    viewStates: [.selectedItems([category.name])]
                )
            }
        }
    }
    
    @ViewBuilder
    private var paginationView: some View {
        if !state.isLoading {
            RefdsPagination(
                currentPage: $state.filter.currentPage,
                color: .accentColor,
                canChangeToNextPage: { state.filter.canChangePage }
            )
        }
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = StoreFactory.development
        
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
