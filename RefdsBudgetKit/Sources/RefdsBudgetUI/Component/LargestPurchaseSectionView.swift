import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct LargestPurchaseSectionView: View {
    private let transactions: [TransactionRowViewDataProtocol]
    
    public init(transactions: [TransactionRowViewDataProtocol]) {
        self.transactions = transactions
    }
    
    public var body: some View {
        RefdsSection {
            TabView {
                ForEach(transactions.indices, id: \.self) { index in
                    rowTransaction(for: index)
                }
            }
            #if os(iOS)
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            #endif
            .frame(height: 260)
            .padding(.horizontal, -20)
        } header: {
            RefdsText(
                .localizable(by: .transactionsLargestPurchaseHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    @ViewBuilder
    private func rowTransaction(for index: Int) -> some View {
        let transaction = transactions[index]
        VStack(spacing: .padding(.medium)) {
            if let icon = RefdsIconSymbol(rawValue: transaction.icon) {
                VStack(spacing: .zero) {
                    RefdsIcon(
                        icon,
                        color: transaction.color,
                        size: 30
                    )
                    .frame(width: 40, height: 40)
                    .padding(10)
                    .background(transaction.color.opacity(0.2))
                    .clipShape(.rect(cornerRadius: .cornerRadius))
                    
                    rankSealView(for: index)
                        .padding(.top, -12)
                }
            }
            
            VStack {
                RefdsText(
                    transaction.amount.currency(),
                    style: .title,
                    weight: .bold
                )
                
                RefdsText(
                    transaction.date.asString(withDateFormat: .custom("EEEE dd, MMMM yyyy")).uppercased(),
                    style: .footnote,
                    color: .secondary,
                    weight: .bold
                )
            }
            .padding(.top, -12)
            
            RefdsText(transaction.description, style: .callout, color: .secondary, alignment: .center)
            Spacer()
        }
        .padding(.padding(.medium))
        .padding(.horizontal, .padding(.extraLarge))
    }
    
    private func rankSealView(for index: Int) -> some View {
        ZStack {
            RefdsIcon(
                .sealFill,
                color: .yellow,
                size: 25
            )
            
            RefdsText(
                (index + 1).asString,
                style: .callout,
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
