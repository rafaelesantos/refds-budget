import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct SystemSmallTransactions: View {
    private let viewData: SystemSmallTransactionsViewDataProtocol
    
    public init(viewData: SystemSmallTransactionsViewDataProtocol) {
        self.viewData = viewData
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            headerView
                .if(hasFilter) {
                    $0.padding(.bottom, 2)
                }
            Spacer(minLength: .zero)
            contentView
            Spacer(minLength: .zero)
            transactionsView
        }
    }
    
    private var hasFilter: Bool {
        viewData.category != String.localizable(by: .transactionsCategorieAllSelected) ||
        viewData.tag != String.localizable(by: .transactionsCategorieAllSelected)
    }
    
    private var header: String {
        viewData.isFilterByDate ? viewData.date.asString(withDateFormat: .custom("MMMM")) :
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
            HStack(spacing: 5) {
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
            
            if !hasFilter {
                RefdsText(
                    .localizable(by: .widgetCurrentSpend).uppercased(),
                    style: .system(size: 7),
                    color: .secondary
                )
            }
            
            RefdsText(
                viewData.spend.currency(),
                style: .title3,
                weight: .bold,
                lineLimit: 1
            )
            .minimumScaleFactor(0.5)
            .if(hasFilter) {
                $0.padding(.top, -6)
            }
            
            Spacer(minLength: .zero)
        }
    }
    
    private var transactionsView: some View {
        VStack(alignment: .leading, spacing: 5) {
            if viewData.transactions.isEmpty {
                RefdsText(
                    .localizable(by: .emptyDescriptions),
                    style: .system(size: 10),
                    color: .secondary
                )
            } else {
                ForEach(viewData.transactions.prefix(4).indices, id: \.self) {
                    let transaction = viewData.transactions[$0]
                    HStack {
                        if let icon = RefdsIconSymbol(rawValue: transaction.icon) {
                            RefdsIcon(icon, color: transaction.color, size: 10)
                                .frame(width: 10, height: 10)
                        }
                        
                        RefdsText(
                            (transaction.description.components(separatedBy: " ").first ?? "") + "...",
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
                }
            }
        }
    }
}

#Preview {
    SystemSmallTransactions(viewData: SystemSmallTransactionsViewDataMock())
        .frame(width: 130, height: 130)
        .refdsCard(padding: .medium, hasShadow: true)
}
