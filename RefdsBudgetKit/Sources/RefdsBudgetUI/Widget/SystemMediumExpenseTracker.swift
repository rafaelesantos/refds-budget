import SwiftUI
import RefdsUI
import Charts
import RefdsShared
import RefdsBudgetPresentation

public struct SystemMediumExpenseTracker: View {
    private let viewData: WidgetTransactionsViewDataProtocol
    
    public init(viewData: WidgetTransactionsViewDataProtocol) {
        self.viewData = viewData
    }
    
    private var hasFilter: Bool {
        viewData.category != String.localizable(by: .transactionsCategorieAllSelected) ||
        viewData.tag != String.localizable(by: .transactionsCategorieAllSelected)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Spacer(minLength: .zero)
            HStack(spacing: .padding(.small)) {
                headerView
                    .frame(width: 120)
                spendView
            }
            chartView
            Spacer(minLength: .zero)
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack {
                RefdsText(
                    .localizable(by: .widgetAppName),
                    style: .system(size: 18),
                    weight: .bold,
                    lineLimit: 1
                )
                
                if viewData.isFilterByDate {
                    RefdsText(
                        viewData.date.asString(withDateFormat: .custom("MMM")).uppercased() + ".",
                        style: .caption2,
                        color: viewData.percent.riskColor,
                        weight: .heavy,
                        lineLimit: 1
                    )
                    .refdsTag(color: viewData.percent.riskColor)
                }
            }
            
            RefdsText(
                viewData.budget.currency(),
                style: .footnote,
                color: .secondary,
                weight: .bold
            )
        }
    }
    
    private var spendView: some View {
        VStack {
            HStack(spacing: .zero) {
                RefdsText(
                    viewData.transactions.count.asString,
                    style: .caption2,
                    color: viewData.percent.riskColor,
                    weight: .bold
                )
                .refdsTag(color: viewData.percent.riskColor)
                .padding(.trailing, 5)
                
                RefdsText(
                    viewData.spend.currency(),
                    style: .footnote,
                    weight: .bold
                )
                
                Spacer(minLength: .zero)
                
                RefdsText(
                    viewData.percent.percent(),
                    style: .footnote,
                    color: .secondary,
                    weight: .bold
                )
            }
            
            ProgressView(value: viewData.percent > 1 ? 1 : viewData.percent, total: 1)
                .tint(viewData.percent.riskColor)
                .padding(.horizontal, 50)
                .scaleEffect(2)
            
            Spacer(minLength: .zero)
        }
    }
    
    private var chartView: some View {
        Chart {
            ForEach(viewData.categories.indices, id: \.self) { index in
                let data = viewData.categories[index]
                buildMark(x: data.name, y: data.budget, id: "budget")
                buildMark(x: data.name, y: data.spend, id: "spend")
            }
        }
        .chartYAxis { AxisMarks(position: .trailing) }
        .chartLegend(.hidden)
        .frame(height: 80)
        .padding(.top)
        .chartForegroundStyleScale([
            "budget": Color.accentColor,
            "spend": viewData.percent.riskColor
        ])
    }
    
    func buildMark(x: String, y: Double, id: String) -> some ChartContent {
        BarMark(
            x: .value("x", x.prefix(3).capitalized + "."),
            y: .value("y", y),
            stacking: .standard
        )
        .foregroundStyle(by: .value("x-style", id))
        .position(by: .value("x-position", id))
    }
}

#Preview {
    SystemMediumExpenseTracker(viewData: WidgetTransactionsViewDataMock())
        .frame(height: 130)
        .refdsCard(padding: .medium, hasShadow: true)
        .padding(.horizontal, .padding(.extraLarge))
}
