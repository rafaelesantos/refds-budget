import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct LargestPurchaseSectionView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.privacyMode) private var privacyMode
    private let transactions: [TransactionRowViewDataProtocol]
    
    public init(transactions: [TransactionRowViewDataProtocol]) {
        self.transactions = transactions
    }
    
    public var body: some View {
        RefdsSection {
            
        } header: {
            RefdsText(
                .localizable(by: .transactionsLargestPurchaseHeader),
                style: .footnote,
                color: .secondary
            )
        } footer: {
            ScrollView(.horizontal) {
                HStack(spacing: .padding(.medium)) {
                    ForEach(transactions.indices, id: \.self) { index in
                        rowTransaction(for: index)
                            .frame(width: 170, height: 125)
                            .padding(.padding(.medium))
                            .if(colorScheme == .light) {
                                $0.background()
                            }
                            .if(colorScheme == .dark) {
                                $0.refdsBackground(with: .secondaryBackground)
                            }
                            .background(colorScheme == .light ? nil : Color.secondary.opacity(0.1))
                            .clipShape(.rect(cornerRadius: .cornerRadius))
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.never)
            .padding(.horizontal, -40)
        }
        .budgetSubscription()
    }
    
    @ViewBuilder
    private func rowTransaction(for index: Int) -> some View {
        let transaction = transactions[index]
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                if let icon = RefdsIconSymbol(rawValue: transaction.icon) {
                    VStack(spacing: .zero) {
                        RefdsIcon(
                            icon,
                            color: transaction.color,
                            size: 15
                        )
                        .frame(width: 25, height: 25)
                        .padding(10)
                        .background(transaction.color.opacity(0.2))
                        .clipShape(.rect(cornerRadius: .cornerRadius))
                        
                        rankSealView(for: index)
                            .padding(.top, -12)
                    }
                }
                
                VStack(alignment: .leading) {
                    RefdsText(
                        transaction.amount.currency(),
                        weight: .bold
                    )
                    .refdsRedacted(if: privacyMode)
                    
                    RefdsText(
                        transaction.date.asString(withDateFormat: .custom("EEEE dd, MMMM yyyy")).uppercased(),
                        style: .caption,
                        color: .secondary,
                        weight: .bold
                    )
                }
            }
            
            Spacer(minLength: .zero)
            
            RefdsText(
                transaction.description,
                style: .callout,
                color: .secondary
            )
            
            Spacer(minLength: .zero)
        }
    }
    
    private func rankSealView(for index: Int) -> some View {
        ZStack {
            RefdsIcon(
                .sealFill,
                color: .yellow,
                size: 20
            )
            
            RefdsText(
                (index + 1).asString,
                style: .caption,
                color: .white,
                weight: .heavy
            )
        }
    }
}

#Preview {
    List {
        LargestPurchaseSectionView(transactions: (1 ... 3).map { _ in TransactionRowViewDataMock() })
    }
}
