import SwiftUI
import RefdsUI
import RefdsShared
import Mock
import Domain
import Presentation

public struct SystemSmallTransactions: View {
    private let viewData: WidgetTransactionsViewDataProtocol
    
    public init(viewData: WidgetTransactionsViewDataProtocol) {
        self.viewData = viewData
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            headerView
            Spacer(minLength: .zero)
            contentView
            Spacer(minLength: .zero)
            transactionsView
        }
    }
    
    private var hasFilter: Bool {
        viewData.category != String.localizable(by: .transactionsCategoriesAllSelected) ||
        viewData.tag != String.localizable(by: .transactionsCategoriesAllSelected)
    }
    
    private var header: String {
        viewData.isFilterByDate ? viewData.date.asString(withDateFormat: .custom("MMM")).capitalized :
            .localizable(by: .homeSpendBudgetSpendTitle)
    }
    
    private var headerView: some View {
        HStack {
            RefdsText(
                header,
                style: .title3,
                weight: .bold,
                lineLimit: 1
            )
            
            Spacer(minLength: .zero)
            
            RefdsText(
                viewData.amount.asString,
                style: .caption2,
                color: .accentColor,
                weight: .heavy,
                lineLimit: 1
            )
            .refdsTag(color: .accentColor)
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 2) {
                if let status = TransactionStatus.allCases.first(where: { $0.description == viewData.status }),
                   let icon = status.icon {
                    RefdsIcon(
                        icon,
                        color: status.color,
                        size: 10
                    )
                    .padding(.trailing, 3)
                }
                
                RefdsText(
                    .localizable(by: .widgetCurrentSpend).uppercased(),
                    style: .system(size: 7),
                    color: .secondary
                )
                .padding(.top, 3)
                
                if hasFilter {
                    RefdsText(
                        "•",
                        style: .system(size: 7),
                        color: .secondary
                    )
                }
                
                if viewData.category != String.localizable(by: .transactionsCategoriesAllSelected) {
                    RefdsText(
                        viewData.category.uppercased(),
                        style: .system(size: 7),
                        color: .secondary,
                        lineLimit: 1
                    )
                }
                
                if viewData.tag != String.localizable(by: .transactionsCategoriesAllSelected) {
                    RefdsText(
                        viewData.tag.uppercased(),
                        style: .system(size: 7),
                        color: .secondary,
                        lineLimit: 1
                    )
                }
            }
            
            RefdsText(
                viewData.spend.currency(),
                style: .title3,
                weight: .bold,
                lineLimit: 1
            )
            .minimumScaleFactor(0.5)
            
            Spacer(minLength: .zero)
        }
    }
    
    private var transactionsView: some View {
        VStack(alignment: .leading, spacing: 2) {
            if viewData.transactions.isEmpty {
                RefdsText(
                    .localizable(by: .emptyDescriptions),
                    style: .system(size: 10),
                    color: .secondary
                )
            } else {
                ForEach(viewData.transactions.prefix(3).indices, id: \.self) {
                    let transaction = viewData.transactions[$0]
                    HStack {
                        if let icon = RefdsIconSymbol(rawValue: transaction.icon) {
                            RefdsIcon(icon, color: transaction.color, size: 8)
                                .frame(width: 12, height: 12)
                                .padding(.horizontal, -3)
                                .refdsTag(color: transaction.color)
                        }
                        
                        RefdsText(
                            transaction.description,
                            style: .system(size: 10),
                            color: .secondary,
                            lineLimit: 1
                        )
                        
                        Spacer(minLength: .zero)
                        
                        RefdsText(
                            transaction.amount.currency(),
                            style: .system(size: 10),
                            lineLimit: 1
                        )
                    }
                    
                    if $0 < 2, $0 < viewData.transactions.count - 1 {
                        Divider()
                            .opacity(0.7)
                            .padding(.leading, 27)
                    }
                }
            }
        }
    }
}

#Preview {
    SystemSmallTransactions(viewData: WidgetTransactionsViewDataMock())
        .frame(width: 130, height: 130)
        .refdsCard(padding: .medium, hasShadow: true)
}
