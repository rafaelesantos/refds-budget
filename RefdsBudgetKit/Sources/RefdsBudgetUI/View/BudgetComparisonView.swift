import SwiftUI
import RefdsUI
import RefdsShared
import RefdsRedux
import RefdsBudgetResource
import RefdsBudgetPresentation

public struct BudgetComparisonView: View {
    @Environment(\.privacyMode) private var privacyMode
    
    @Binding private var state: BudgetComparisonStateProtocol
    private let action: (BudgetComparisonAction) -> Void
    
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
            sectionRedoComparisonButton
        }
        .onAppear { action(.fetchData) }
    }
    
    @ViewBuilder
    private var sectionTitle: some View {
        if let baseBudget = state.baseBudget,
           let compareBudget = state.compareBudget {
            RefdsSection {} footer: {
                ZStack {
                    HStack(spacing: .padding(.large)) {
                        VStack(spacing: 5) {
                            RefdsText(
                                baseBudget.date.asString(withDateFormat: .custom("yyyy")),
                                style: .footnote,
                                color: .secondary,
                                weight: .bold
                            )
                                .padding(.bottom, -10)
                            RefdsText(
                                baseBudget.date.asString(withDateFormat: .custom("MMMM")).capitalized,
                                style: .title,
                                weight: .bold,
                                lineLimit: 1
                            )
                                .minimumScaleFactor(0.8)
                            RefdsScaleProgressView(
                                .circle,
                                riskColor: baseBudget.percentage.riskColor,
                                size: 25
                            )
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 5) {
                            RefdsText(
                                compareBudget.date.asString(withDateFormat: .custom("yyyy")),
                                style: .footnote,
                                color: .secondary,
                                weight: .bold
                            )
                                .padding(.bottom, -10)
                            RefdsText(
                                compareBudget.date.asString(
                                    withDateFormat: .custom("MMMM")
                                ).capitalized,
                                style: .title,
                                weight: .bold,
                                lineLimit: 1
                            )
                                .minimumScaleFactor(0.8)
                            RefdsScaleProgressView(
                                .circle,
                                riskColor: compareBudget.percentage.riskColor,
                                size: 25
                            )
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack { Divider().frame(height: 100) }
                    RefdsText(
                        .localizable(by: .comparisonBudgetVS).uppercased(),
                        color: .secondary,
                        weight: .bold
                    )
                        .padding(3)
                        .padding(.horizontal, 3)
                        .background()
                        .cornerRadius(4)
                }
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
                compareValue: compareBudget.spend
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
                    ChartComparisonView(
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
                    ChartComparisonView(
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
                compareValue: selection.compare
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
        compareValue: Double
    ) -> some View {
        VStack(spacing: .zero) {
            HStack {
                Spacer(minLength: .zero)
                
                VStack {
                    RefdsText(
                        baseDate.uppercased(),
                        style: .caption,
                        color: .accentColor.opacity(0.5),
                        weight: .bold
                    )
                    RefdsText(
                        baseValue.currency(),
                        style: .title3,
                        weight: .bold,
                        lineLimit: 1
                    )
                    .contentTransition(.numericText())
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
                        color: .accentColor,
                        weight: .bold
                    )
                    RefdsText(
                        compareValue.currency(),
                        style: .title3,
                        weight: .bold,
                        lineLimit: 1
                    )
                    .contentTransition(.numericText())
                    .refdsRedacted(if: privacyMode)
                }
                .frame(maxWidth: .infinity)
                
                Spacer(minLength: .zero)
            }
            .frame(maxWidth: .infinity)
            
            BarComparisonView(
                baseValue: baseValue,
                compareValue: compareValue
            )
        }
        .frame(maxWidth: .infinity)
    }
    
    private var sectionRedoComparisonButton: some View {
        RefdsSection {} footer: {
            RefdsButton(.localizable(by: .comparisonBudgetBackButton)) {
                action(.dismiss)
            }
        }
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
