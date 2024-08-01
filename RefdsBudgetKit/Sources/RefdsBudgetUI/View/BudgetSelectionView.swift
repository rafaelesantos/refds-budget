import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsBudgetResource
import RefdsBudgetPresentation

public struct BudgetSelectionView: View {
    @Environment(\.privacyMode) private var privacyMode
    
    @Binding private var state: BudgetSelectionStateProtocol
    private let action: (BudgetSelectionAction) -> Void
    
    public init(
        state: Binding<BudgetSelectionStateProtocol>,
        action: @escaping (BudgetSelectionAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    public var body: some View {
        List(selection: $state.budgetsSelected) {
            sectionEmptyBudgets
            sectionBudgets
        }
        .navigationTitle(String.localizable(by: .comparisonBudgetSelection))
        .environment(\.editMode, .constant(.active))
        .onAppear { action(.fetchData) }
        .onChange(of: state.budgetsSelected) {
            if state.budgetsSelected.count >= 2 {
                action(.showComparison)
            }
        }
    }
    
    private var sectionBudgets: some View {
        ForEach(state.budgets.indices, id: \.self) { i in
            let budgets = state.budgets[i]
            RefdsSection {
                ForEach(budgets.indices, id: \.self) { j in
                    let budget = budgets[j]
                    budgetItemView(for: budget)
                        .id(budget.id)
                        .tag(budget.id)
                }
            } header: {
                if let year = budgets.first?.date.asString(withDateFormat: .year) {
                    RefdsText(
                        year,
                        style: .footnote,
                        color: .secondary
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    private var sectionEmptyBudgets: some View {
        let budgets = state.budgets.flatMap { $0 }
        if budgets.count < 2 {
            RefdsText(.localizable(by: .categoriesEmptyBudgetsDescription), style: .callout)
            RefdsButton { action(.addBudget) } label: {
                RefdsText(.localizable(by: .categoriesEmptyBudgetsButton), style: .callout, color: .accentColor)
            }
        }
    }
    
    private func budgetItemView(for budget: BudgetRowViewDataProtocol) -> some View {
        HStack {
            VStack(alignment: .leading) {
                RefdsText(budget.date.asString(withDateFormat: .custom("MMMM")).capitalized)
                if let description = budget.description, !description.isEmpty {
                    RefdsText(description, style: .callout, color: .secondary, lineLimit: 2)
                }
            }
            Spacer()
            
            VStack(alignment: .center, spacing: .padding(.extraSmall)) {
                RefdsText(budget.amount.currency(), style: .callout, weight: .bold)
                    .refdsRedacted(if: privacyMode)
                RefdsScaleProgressView(.circle, riskColor: budget.percentage.riskColor, size: 25)
            }
        }
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = StoreFactory.development
        
        var body: some View {
            NavigationStack {
                BudgetSelectionView(state: $store.state.budgetSelectionState) {
                    store.dispatch(action: $0)
                }
            }
        }
    }
    return ContainerView()
}
