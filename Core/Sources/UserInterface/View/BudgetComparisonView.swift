import SwiftUI
import RefdsUI
import RefdsShared
import Mock
import Domain
import Presentation

public struct BudgetComparisonView: View {
    @Environment(\.privacyMode) private var privacyMode
    
    @Binding private var state: BudgetComparisonStateProtocol
    private let action: (BudgetComparisonAction) -> Void
    
    @State private var categoryVariation: Double?
    
    public init(
        state: Binding<BudgetComparisonStateProtocol>,
        action: @escaping (BudgetComparisonAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    public var body: some View {
        List {
            sectionTitle
            sectionComparison
            sectionComparisonCategoriesChart
            sectionComparisonTagsChart
        }
        .onAppear { action(.fetchData) }
    }
    
    @ViewBuilder
    private var sectionTitle: some View {
        if let baseBudget = state.baseBudget,
           let compareBudget = state.compareBudget {
            RefdsSection {} footer: {
                VStack(spacing: .padding(.medium)) {
                    if baseBudget.hasAI {
                        titleView(for: baseBudget)
                    } else {
                        titleView(for: baseBudget)
                        Divider()
                        titleView(for: compareBudget)
                    }
                }
                .padding(.top, -20)
            }
        }
    }
    
    private func titleView(for budget: BudgetItemViewDataProtocol) -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(alignment: .bottom) {
                RefdsText(
                    budget.date.asString(withDateFormat: .custom("MMMM")).capitalized,
                    style: .largeTitle,
                    weight: .bold,
                    lineLimit: 1
                )
                
                RefdsText(
                    budget.date.asString(withDateFormat: .custom("yyyy")),
                    style: .body,
                    color: .secondary,
                    weight: .bold
                )
                .padding(.bottom, 5)
                
                Spacer()
                
                if budget.hasAI {
                    RefdsIconRow(.cpuFill)
                        .clipShape(.circle)
                } else {
                    RefdsScaleProgressView(
                        .circle,
                        riskColor: budget.percentage.riskColor,
                        size: 25
                    )
                }
            }
            
            if budget.hasAI {
                RefdsScaleProgressView(
                    .circle,
                    riskColor: budget.percentage.riskColor,
                    size: 30
                )
                .padding(.top, .padding(.extraSmall))
            }
        }
    }
    
    @ViewBuilder
    private var sectionComparison: some View {
        if let baseBudget = state.baseBudget,
           let compareBudget = state.compareBudget {
            let baseVariation = 1 - baseBudget.percentage
            let compareVariation = 1 - compareBudget.percentage
            let variation = compareVariation - baseVariation
            RefdsSection {
                rowComparisonVariation(
                    title: .localizable(by: .comparisonBudgetVariation),
                    variation: variation
                )
                rowComparisonValues
            } header: {
                RefdsText(
                    .localizable(by: .comparisonBudgetPerformance),
                    style: .footnote,
                    color: .secondary
                )
            }
        }
    }
    
    private func rowComparisonVariation(
        title: String,
        variation: Double
    ) -> some View {
        HStack(spacing: 15) {
            let color: Color = variation < .zero ? .red : variation > .zero ? .green : .orange
            
            RefdsText(title.capitalizedSentence)
            Spacer(minLength: .zero)
            RefdsText(
                variation.percent(),
                color: color,
                weight: .bold
            )
            .contentTransition(.numericText())
            .animation(.default, value: variation)
        }
    }
    
    @ViewBuilder
    private var rowComparisonValues: some View {
        if let baseBudget = state.baseBudget,
           let compareBudget = state.compareBudget {
            let baseDate = baseBudget.date.asString(withDateFormat: .custom("MMMM yyyy"))
            let compareDate = compareBudget.date.asString(withDateFormat: .custom("MMMM yyyy"))
            let baseVariation = 1 - baseBudget.percentage
            let compareVariation = 1 - compareBudget.percentage
            comparisonValuesView(
                baseDate: baseDate,
                compareDate: compareDate,
                baseValue: baseBudget.spend,
                compareValue: compareBudget.spend,
                color: .accentColor,
                hasAI: baseBudget.hasAI
            )
            
            RefdsText(
                .localizable(by: .comparisonBudgetPerformanceDescription, with: baseDate, baseVariation.percent(), compareDate, compareVariation.percent()),
                style: .callout,
                color: .secondary
            )
        }
    }
    
    @ViewBuilder
    private var sectionComparisonCategoriesChart: some View {
        if !state.categoriesChart.isEmpty {
            RefdsSection {
                rowChartSelectionVariation(for: state.selectedCategory)
                RefdsStories(
                    selection: bindingSelectionCategory,
                    stories: state.categoriesChart.map {
                        RefdsStoriesViewData(
                            name: $0.domain,
                            color: $0.color ?? .accentColor,
                            icon: $0.icon ?? .dollarsign
                        )
                    }
                )
                VStack(spacing: .zero) {
                    rowChartSelectionComparison(for: state.selectedCategory)
                    ComparisonChartView(
                        viewData: state.categoriesChart,
                        selection: $state.selectedCategory
                    )
                    .padding(.top, -10)
                }
                .frame(maxWidth: .infinity)
            } header: {
                RefdsText(
                    .localizable(by: .comparisonBudgetCategoryPerformance),
                    style: .footnote,
                    color: .secondary
                )
            }
        }
    }
    
    @ViewBuilder
    private var sectionComparisonTagsChart: some View {
        if !state.tagsChart.isEmpty {
            RefdsSection {
                RefdsStories(
                    selection: bindingSelectionTag,
                    stories: state.tagsChart.map {
                        RefdsStoriesViewData(
                            name: $0.domain,
                            color: $0.color ?? .accentColor,
                            icon: $0.icon ?? .dollarsign
                        )
                    }
                )
                
                VStack(spacing: .zero) {
                    rowChartSelectionComparison(for: state.selectedTag)
                    ComparisonChartView(
                        viewData: state.tagsChart,
                        selection: $state.selectedTag,
                        hasDomain: false
                    )
                    .padding(.top, -10)
                }
                .frame(maxWidth: .infinity)
            } header: {
                RefdsText(
                    .localizable(by: .comparisonBudgetTagComparison),
                    style: .footnote,
                    color: .secondary
                )
            }
        }
    }
    
    private var bindingSelectionCategory: Binding<String?> {
        Binding {
            state.selectedCategory?.domain
        } set: { selection in
            if let tag = state.categoriesChart.first(where: { $0.domain == selection }) {
                withAnimation {
                    state.selectedCategory = tag
                }
            }
        }
    }
    
    private var bindingSelectionTag: Binding<String?> {
        Binding {
            state.selectedTag?.domain
        } set: { selection in
            if let tag = state.tagsChart.first(where: { $0.domain == selection }) {
                withAnimation {
                    state.selectedTag = tag
                }
            }
        }
    }
    
    @ViewBuilder
    private func rowChartSelectionComparison(for selection: BudgetComparisonChartViewDataProtocol?) -> some View {
        if let baseBudget = state.baseBudget,
           let compareBudget = state.compareBudget,
           let selection = selection {
            let baseDate = baseBudget.date.asString(withDateFormat: .custom("MMMM, yyyy"))
            let compareDate = compareBudget.date.asString(withDateFormat: .custom("MMMM, yyyy"))
            comparisonValuesView(
                baseDate: baseDate,
                compareDate: compareDate,
                baseValue: selection.base,
                compareValue: selection.compare,
                color: selection.color ?? .accentColor,
                hasAI: state.baseBudget?.hasAI ?? false
            )
        }
    }
    
    @ViewBuilder
    private func rowChartSelectionVariation(for selection: BudgetComparisonChartViewDataProtocol?) -> some View {
        if let selection = selection {
            let baseVariation = 1 - (selection.base / (selection.budgetBase == .zero ? 1 : selection.budgetBase))
            let compareVariation = 1 - (selection.compare / (selection.budgetCompare == .zero ? 1 : selection.budgetCompare))
            let variation = compareVariation - baseVariation
            rowComparisonVariation(
                title: .localizable(by: .comparisonBudgetVariation),
                variation: variation
            )
        }
    }
    
    private func comparisonValuesView(
        baseDate: String,
        compareDate: String,
        baseValue: Double,
        compareValue: Double,
        color: Color,
        hasAI: Bool
    ) -> some View {
        VStack(spacing: .zero) {
            HStack {
                Spacer(minLength: .zero)
                
                VStack {
                    HStack(spacing: 3) {
                        if hasAI {
                            RefdsIcon(
                                .cpuFill,
                                color: color.opacity(0.5),
                                style: .footnote
                            )
                        }
                        
                        RefdsText(
                            baseDate.uppercased(),
                            style: .caption,
                            color: color.opacity(0.5),
                            weight: .bold
                        )
                    }
                    
                    RefdsText(
                        baseValue.currency(),
                        style: .title3,
                        weight: .bold,
                        lineLimit: 1
                    )
                    .contentTransition(.numericText())
                    .animation(.default, value: baseValue)
                    .refdsRedacted(if: privacyMode)
                }
                .frame(maxWidth: .infinity)
                
                Spacer(minLength: .zero)
                RefdsIcon(.xmark, color: .secondary)
                Spacer(minLength: .zero)
                
                VStack {
                    RefdsText(
                        compareDate.uppercased(),
                        style: .caption,
                        color: color,
                        weight: .bold
                    )
                    
                    RefdsText(
                        compareValue.currency(),
                        style: .title3,
                        weight: .bold,
                        lineLimit: 1
                    )
                    .contentTransition(.numericText())
                    .animation(.default, value: compareValue)
                    .refdsRedacted(if: privacyMode)
                }
                .frame(maxWidth: .infinity)
                
                Spacer(minLength: .zero)
            }
            .frame(maxWidth: .infinity)
            
            ComparisonBarView(
                baseValue: baseValue,
                compareValue: compareValue,
                color: color
            )
            .animation(.default, value: baseValue)
            .animation(.default, value: compareValue)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = StoreFactory.development
        
        var body: some View {
            NavigationStack {
                BudgetComparisonView(state: $store.state.budgetComparisonState) {
                    store.dispatch(action: $0)
                }
            }
        }
    }
    return ContainerView()
}
