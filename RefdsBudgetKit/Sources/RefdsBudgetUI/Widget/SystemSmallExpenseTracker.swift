import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetDomain
import RefdsBudgetPresentation

public struct SystemSmallExpenseTracker: View {
    private let viewData: WidgetExpenseTrackerViewDataProtocol
    
    public init(viewData: WidgetExpenseTrackerViewDataProtocol) {
        self.viewData = viewData
    }
    
    private var hasFilter: Bool {
        viewData.category != String.localizable(by: .transactionsCategorieAllSelected) ||
        viewData.tag != String.localizable(by: .transactionsCategorieAllSelected)
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            headerView
            Spacer(minLength: .zero)
            contentView
            Spacer(minLength: .zero)
            remainingView
        }
    }
    
    private var headerView: some View {
        HStack {
            RefdsText(
                .localizable(by: .widgetAppName),
                style: .title3,
                weight: .bold,
                lineLimit: 1
            )
            
            Spacer(minLength: .zero)
            
            if viewData.isFilterByDate {
                RefdsText(
                    viewData.date.asString(withDateFormat: .custom("MMM")).uppercased(),
                    style: .footnote,
                    color: viewData.percent.riskColor,
                    weight: .heavy,
                    lineLimit: 1
                )
                .refdsTag(color: viewData.percent.riskColor)
            }
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading) {
            RefdsText(
                .localizable(by: .widgetCurrentSpend).uppercased(),
                style: .system(size: 7),
                color: .secondary
            )
            
            RefdsText(
                viewData.spend.currency(),
                style: .title3,
                color: viewData.percent.riskColor,
                weight: .bold,
                lineLimit: 1
            )
            .minimumScaleFactor(0.5)
            
            RefdsText(
                viewData.budget.currency(),
                style: .title3,
                weight: .bold,
                lineLimit: 1
            )
            .minimumScaleFactor(0.5)
            .if(hasFilter) { view in
                view.padding(.bottom, -7)
            }
            
            HStack(spacing: 3) {
                if !hasFilter {
                    RefdsText(
                        .localizable(by: .widgetTotalBudget).uppercased(),
                        style: .system(size: 7),
                        color: .secondary,
                        lineLimit: 1
                    )
                }
                
                if viewData.category != String.localizable(by: .transactionsCategorieAllSelected) {
                    RefdsText(
                        viewData.category.uppercased(),
                        style: .system(size: 7),
                        color: .primary,
                        weight: .heavy,
                        lineLimit: 1
                    )
                    .refdsTag()
                }
                
                if viewData.tag != String.localizable(by: .transactionsCategorieAllSelected) {
                    RefdsText(
                        viewData.tag.uppercased(),
                        style: .system(size: 7),
                        color: .primary,
                        weight: .heavy,
                        lineLimit: 1
                    )
                    .refdsTag()
                }
            }
        }
    }
    
    private var remainingView: some View {
        VStack(alignment: .leading) {
            if !hasFilter {
                RefdsText(
                    .localizable(by: .widgetRemaining).uppercased(),
                    style: .system(size: 7),
                    color: .secondary,
                    lineLimit: 1
                )
            }
            
            HStack {
                if let status = TransactionStatus.allCases.first(where: { $0.description == viewData.status }),
                   let icon = status.icon {
                    RefdsIcon(
                        icon,
                        color: status.color,
                        size: 10
                    )
                    .padding(.trailing, -5)
                }
                
                RefdsText(
                    viewData.remaining.currency(),
                    style: .system(size: 12),
                    color: viewData.percent.riskColor,
                    weight: .bold
                )
                
                Spacer(minLength: .zero)
                
                RefdsText(
                    (1 - viewData.percent).percent(),
                    style: .system(size: 12),
                    weight: .bold
                )
            }
            
            ProgressView(value: viewData.percent > 1 ? 1 : viewData.percent, total: 1)
                .tint(viewData.percent.riskColor)
                .scaleEffect(2)
                .padding(.horizontal, 34)
        }
    }
}

#Preview {
    SystemSmallExpenseTracker(viewData: WidgetExpenseTrackerViewDataMock())
        .frame(width: 130, height: 130)
        .refdsCard(padding: .medium, hasShadow: true)
}
