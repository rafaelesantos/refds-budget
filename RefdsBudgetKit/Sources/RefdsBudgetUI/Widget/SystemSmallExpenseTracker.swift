import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct SystemSmallExpenseTracker: View {
    private let viewData: SystemSmallExpenseTrackerViewDataProtocol
    
    public init(viewData: SystemSmallExpenseTrackerViewDataProtocol) {
        self.viewData = viewData
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
                    viewData.date.asString(withDateFormat: .custom("MMM")).uppercased() + ".",
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
            
            RefdsText(
                .localizable(by: .widgetTotalBudget).uppercased(),
                style: .system(size: 7),
                color: .secondary,
                lineLimit: 1
            )
        }
    }
    
    private var remainingView: some View {
        VStack(alignment: .leading) {
            RefdsText(
                .localizable(by: .widgetRemaining).uppercased(),
                style: .system(size: 7),
                color: .secondary,
                lineLimit: 1
            )
            
            HStack {
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
                .padding(.horizontal, 32)
        }
    }
}

#Preview {
    SystemSmallExpenseTracker(viewData: SystemSmallExpenseTrackerViewDataMock())
        .frame(width: 130, height: 130)
        .refdsCard(padding: .medium, hasShadow: true)
}
