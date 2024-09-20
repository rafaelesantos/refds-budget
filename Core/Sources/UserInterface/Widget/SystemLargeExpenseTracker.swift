import SwiftUI
import RefdsUI
import Charts
import RefdsShared
import Mock
import Domain
import Presentation

public struct SystemLargeExpenseTracker: View {
    private let viewData: WidgetTransactionsViewDataProtocol
    
    public init(viewData: WidgetTransactionsViewDataProtocol) {
        self.viewData = viewData
    }
    
    private var hasFilter: Bool {
        viewData.category != String.localizable(by: .transactionsCategoriesAllSelected) ||
        viewData.tag != String.localizable(by: .transactionsCategoriesAllSelected)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Spacer(minLength: .zero)
            HStack(spacing: .small) {
                headerView
                    .frame(width: 120)
                spendView
            }
            contentCategoriesView
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
                        viewData.date.asString(withDateFormat: .custom("MMM")).uppercased(),
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
            
            Spacer(minLength: .zero)
        }
    }
    
    private var spendView: some View {
        VStack {
            HStack(spacing: .zero) {
                if let status = TransactionStatus.allCases.first(where: { $0.description == viewData.status }),
                   let icon = status.icon {
                    RefdsIcon(
                        icon,
                        color: status.color,
                        size: 15
                    )
                    .padding(.trailing, 5)
                }
                
                RefdsText(
                    viewData.transactions.count.asString,
                    style: .caption2,
                    color: viewData.percent.riskColor,
                    weight: .bold,
                    lineLimit: 1
                )
                .refdsTag(color: viewData.percent.riskColor)
                .padding(.trailing, 5)
                
                RefdsText(
                    viewData.spend.currency(),
                    style: .footnote,
                    weight: .bold,
                    lineLimit: 1
                )
                
                Spacer(minLength: .zero)
                
                RefdsText(
                    viewData.percent.percent(),
                    style: .footnote,
                    color: .secondary,
                    weight: .bold,
                    lineLimit: 1
                )
            }
            
            ProgressView(value: viewData.percent > 1 ? 1 : viewData.percent, total: 1)
                .tint(viewData.percent.riskColor)
                .padding(.horizontal, 50)
                .scaleEffect(2)
            
            Spacer(minLength: .zero)
        }
    }
    
    private var contentCategoriesView: some View {
        LazyVGrid(columns: [.init(spacing: 10), .init(spacing: 10)]) {
            ForEach(viewData.categories.prefix(6).indices, id: \.self) {
                let category = viewData.categories[$0]
                HStack {
                    if let icon = RefdsIconSymbol(rawValue: category.icon) {
                        RefdsIcon(icon, color: category.color, size: 13)
                            .frame(width: 18, height: 18)
                            .padding(.horizontal, -3)
                            .refdsTag(color: category.color)
                    }
                    
                    VStack {
                        HStack {
                            RefdsText(category.name.capitalized, style: .caption2, weight: .bold, lineLimit: 1)
                            Spacer(minLength: .zero)
                            RefdsText(category.percentage.percent(), style: .caption2, lineLimit: 1)
                        }
                        
                        ProgressView(value: category.percentage > 1 ? 1 : category.percentage, total: 1)
                            .tint(category.percentage.riskColor)
                            .scaleEffect(1.8)
                            .padding(.horizontal, 28)
                    }
                }
                .padding(.vertical, 3)
            }
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
        .frame(height: 150)
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
    SystemLargeExpenseTracker(viewData: WidgetTransactionsViewDataMock())
        .frame(height: 320)
        .refdsCard(padding: .medium, hasShadow: true)
        .padding(.horizontal, .extraLarge)
}
