import SwiftUI
import RefdsUI
import RefdsShared
import Mock
import Domain
import Presentation

public struct SystemSmallExpenseProgress: View {
    private let viewData: WidgetExpensesViewDataProtocol
    
    public init(viewData: WidgetExpensesViewDataProtocol) {
        self.viewData = viewData
    }
    
    public var body: some View {
        VStack {
            headerView
            Spacer(minLength: .zero)
            contentView
            Spacer(minLength: .zero)
        }
    }
    
    private var headerView: some View {
        HStack(spacing: .extraSmall) {
            RefdsText(
                .localizable(by: .widgetAppName),
                style: .title3,
                weight: .bold,
                lineLimit: 1
            )
            
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
        VStack(spacing: 10) {
            RefdsText(
                viewData.spend.currency(),
                style: .system(size: 15),
                color: .secondary,
                weight: .bold,
                lineLimit: 1
            )
            .minimumScaleFactor(0.8)
            
            ZStack {
                RefdsCircularProgressView(
                    viewData.percent,
                    size: 90,
                    color: viewData.percent.riskColor,
                    hasAnimation: false
                )
                
                if let status = TransactionStatus.allCases.first(where: { $0.description == viewData.status }),
                   let icon = status.icon {
                    RefdsIcon(
                        icon,
                        color: status.color,
                        size: 15
                    )
                    .padding(.top, -25)
                }
            }
            .padding(.bottom, -15)
            
            HStack(spacing: 3) {
                if viewData.category != String.localizable(by: .transactionsCategoriesAllSelected) {
                    RefdsText(
                        viewData.category.uppercased(),
                        style: .system(size: 7),
                        color: .primary,
                        weight: .heavy,
                        lineLimit: 1
                    )
                    .refdsTag()
                }
                
                if viewData.tag != String.localizable(by: .transactionsCategoriesAllSelected) {
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
    SystemSmallExpenseProgress(viewData: WidgetExpensesViewDataMock())
        .frame(width: 130, height: 130)
        .refdsCard(padding: .medium, hasShadow: true)
}
