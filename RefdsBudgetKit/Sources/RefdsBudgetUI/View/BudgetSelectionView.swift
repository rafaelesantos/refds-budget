import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsBudgetResource
import RefdsBudgetPresentation

public struct BudgetSelectionView: View {
    @Environment(\.navigate) private var navigate
    @Environment(\.privacyMode) private var privacyMode
    
    @State private var editMode: EditMode = .active
    @State private var showAIView: Bool = false
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
        ZStack {
            if showAIView {
                aiContentView
            } else {
                selectionContentView
            }
        }
        .onDisappear { showAIView = false }
    }
    
    private var selectionContentView: some View {
        List(selection: $state.budgetsSelected) {
            sectionEmptyBudgets
            sectionBudgets
        }
        .navigationTitle(String.localizable(by: .comparisonBudgetSelection))
        .environment(\.editMode, $editMode)
        .onChange(of: state.budgetsSelected) { handler() }
        .onAppear {
            withAnimation { editMode = .active }
            action(.fetchData)
        }
    }
    
    @ViewBuilder
    private var aiContentView: some View {
        let budgets = state.budgets.flatMap { $0 }
        if state.hasAI,
           let budgetId = state.budgetsSelected.first,
           let budget = budgets.first(where: { $0.id == budgetId }) {
               ComparisonAIView(for: budget.date) {
                   navigate?.to(
                    scene: .current,
                    view: .budgetComparison,
                    viewStates: [
                        .hasAI(state.hasAI),
                        .baseBudgetDate(budget.date.asString(withDateFormat: .monthYear))
                    ]
                   )
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                       editMode = .inactive
                   }
               }
           }
    }
    
    private func handler() {
        guard state.budgetsSelected.count == 2 else {
            if state.budgetsSelected.count == 1, !showAIView, state.hasAI {
                withAnimation { showAIView = true }
            }
            return
        }
        
        let budgets = state.budgets.flatMap { $0 }
        guard let baseBudget = budgets.first(where: { Array(state.budgetsSelected)[safe: 0] == $0.id }),
              let compareBudget = budgets.first(where: { Array(state.budgetsSelected)[safe: 1] == $0.id })
        else { return }
        
        navigate?.to(
         scene: .current,
         view: .budgetComparison,
         viewStates: [
             .hasAI(state.hasAI),
             .baseBudgetDate(baseBudget.date.asString(withDateFormat: .monthYear)),
             .compareBudgetDate(compareBudget.date.asString(withDateFormat: .monthYear))
         ]
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            editMode = .inactive
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
        if budgets.count < (state.hasAI ? 1 : 2) {
            RefdsText(.localizable(by: .categoriesEmptyBudgetsDescription), style: .callout)
            RefdsButton {
                navigate?.to(
                    scene: .current,
                    view: .addBudget,
                    viewStates: []
                )
            } label: {
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
