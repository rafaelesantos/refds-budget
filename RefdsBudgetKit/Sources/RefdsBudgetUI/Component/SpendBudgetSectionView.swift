import SwiftUI
import RefdsUI
import Charts
import RefdsShared
import RefdsBudgetPresentation

public struct SpendBudgetSectionView: View {
    @Environment(\.privacyMode) private var privacyMode
    @State private var chartSelection: String = ""
    private let viewData: [CategoryRowViewDataProtocol]
    
    public init(viewData: [CategoryRowViewDataProtocol]) {
        self.viewData = viewData
    }
    
    public var body: some View {
        RefdsSection {
            Group {
                if let category = viewData.first(where: { $0.name == chartSelection }) {
                    compareCategorySelected(category)
                    comparePercentView(category)
                    compareView(category)
                        .listRowSeparator(.hidden, edges: .bottom)
                }
                chartView
                    .padding(.top, -40)
            }
            .budgetSubscription()
        } header: {
            RefdsText(
                .localizable(by: .homeSpendBudgetHeader),
                style: .footnote,
                color: .secondary
            )
        }
        .onChange(of: viewData.first?.name ?? "") { reload() }
        .onAppear { reload() }
    }
    
    private func reload() {
        withAnimation {
            chartSelection = viewData.first?.name ?? ""
        }
    }
    
    private func compareCategorySelected(_ category: CategoryRowViewDataProtocol) -> some View {
        HStack(spacing: .padding(.small)) {
            RefdsText(.localizable(by: .homeSpendBudgetCategory), style: .callout)
            Spacer()
            RefdsText(category.name.capitalized, style: .callout, color: .secondary)
        }
    }
    
    private func compareView(_ category: CategoryRowViewDataProtocol) -> some View {
        HStack {
            Spacer(minLength: .zero)
            
            VStack(alignment: .leading, spacing: .zero) {
                HStack(spacing: .padding(.small)) {
                    BubbleColorView(color: .accentColor, isSelected: true, size: 14)
                    RefdsText(.localizable(by: .homeSpendBudgetBudgetTitle), style: .callout, color: .secondary)
                }
                RefdsText(category.budget.currency(), style: .title3, weight: .bold)
                    .contentTransition(.numericText())
                    .refdsRedacted(if: privacyMode)
            }
            
            Spacer(minLength: .zero)
            RefdsIcon(.xmark, color: .secondary)
            Spacer(minLength: .zero)
            
            VStack(alignment: .trailing, spacing: .zero) {
                HStack(spacing: .padding(.small)) {
                    RefdsText(.localizable(by: .homeSpendBudgetSpendTitle), style: .callout, color: .secondary)
                    BubbleColorView(color: .teal, isSelected: true, size: 14)
                }
                RefdsText(category.spend.currency(), style: .title3, weight: .bold)
                    .contentTransition(.numericText())
                    .refdsRedacted(if: privacyMode)
            }
            
            Spacer(minLength: .zero)
        }
        .padding(.padding(.small))
    }
    
    private func comparePercentView(_ category: CategoryRowViewDataProtocol) -> some View {
        HStack {
            RefdsText(.localizable(by: .homeSpendBudgetPercentageResult), style: .callout)
            Spacer()
            BubbleColorView(
                color: category.percentage.riskColor,
                isSelected: true,
                size: 14
            )
            RefdsText(category.percentage.percent())
                .refdsRedacted(if: privacyMode)
                .contentTransition(.numericText())
        }
    }
    
    private var chartView: some View {
        Chart {
            ForEach(viewData.indices, id: \.self) { index in
                let data = viewData[index]
                buildMark(x: data.name, y: data.budget, id: "budget")
                buildMark(x: data.name, y: data.spend, id: "spend")
            }
        }
        .chartYAxis { AxisMarks(position: .trailing) }
        .chartLegend(.hidden)
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 3)
        .frame(height: 120)
        .padding(.vertical)
        .padding(.top)
        .chartForegroundStyleScale([
            "budget": Color.accentColor,
            "spend": Color.teal
        ])
        .chartOverlay { proxy in
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(.clear)
                        .contentShape(.rect)
                        .onTapGesture { location in
                            guard let plotFrame = proxy.plotFrame else { return }
                            let position = location.x - geometry[plotFrame].origin.x
                            guard let category: String = proxy.value(atX: position) else { return }
                            withAnimation { chartSelection = category }
                        }
                }
            }
        }
    }
    
    func buildMark(x: String, y: Double, id: String) -> some ChartContent {
        BarMark(
            x: .value("x", x),
            y: .value("y", y),
            width: 20,
            stacking: .standard
        )
        .foregroundStyle(by: .value("x-style", id))
        .position(by: .value("x-position", id))
    }
}

#Preview {
    List {
        SpendBudgetSectionView(viewData: (1 ... 5).map { _ in CategoryRowViewDataMock() })
    }
}
