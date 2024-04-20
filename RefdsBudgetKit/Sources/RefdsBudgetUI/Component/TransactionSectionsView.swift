import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetResource
import RefdsBudgetPresentation

public struct TransactionSectionsView: View {
    private let viewData: [[TransactionRowViewDataProtocol]]
    private let action: ((TransactionRowViewDataProtocol) -> Void)?
    private let remove: ((UUID) -> Void)?
    
    public init(
        viewData: [[TransactionRowViewDataProtocol]],
        action: ((TransactionRowViewDataProtocol) -> Void)? = nil,
        remove: ((UUID) -> Void)? = nil
    ) {
        self.viewData = viewData
        self.action = action
        self.remove = remove
    }
    
    public var body: some View {
        if viewData.isEmpty {
            RefdsSection {
                EmptyRowView(title: .emptyTransactionsTitle)
            } header: {
                RefdsText(
                    .localizable(by: .categoryTransactionsHeader),
                    style: .footnote,
                    color: .secondary
                )
            }
        } else {
            ForEach(viewData.indices, id: \.self) { index in
                let transactions = viewData[index]
                RefdsSection {
                    ForEach(transactions.indices, id: \.self) { index in
                        let transaction = transactions[index]
                        RefdsButton { action?(transaction) } label: {
                            transactionRow(transaction)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            swipeRemoveButton(for: transaction.id)
                        }
                        .contextMenu {
                            removeButton(for: transaction.id)
                        }
                        .id(transaction.id)
                        .tag(transaction.id)
                    }
                } header: {
                    if let date = transactions.first?.date {
                        HStack {
                            RefdsText(date.asString(withDateFormat: .custom("dd MMMM, yyyy")), style: .footnote, color: .secondary)
                            Spacer()
                            RefdsText(date.asString(withDateFormat: .custom("EEEE")), style: .footnote, color: .secondary)
                        }
                    }
                }
            }
        }
    }
    
    private func transactionRow(_ transaction: TransactionRowViewDataProtocol) -> some View {
        HStack(spacing: .padding(.medium)) {
            if let icon = RefdsIconSymbol(rawValue: transaction.icon) {
                RefdsIcon(
                    icon,
                    color: transaction.color,
                    size: .padding(.medium)
                )
                .frame(width: .padding(.medium), height: .padding(.medium))
                .padding(10)
                .background(transaction.color.opacity(0.2))
                .clipShape(.rect(cornerRadius: .cornerRadius))
            }
            
            HStack {
                VStack(alignment: .leading, spacing: .padding(.extraSmall)) {
                    HStack(spacing: .padding(.small)) {
                        RefdsText(transaction.amount.currency(), style: .callout, lineLimit: 1)
                        Spacer(minLength: .zero)
                        RefdsText(transaction.date.asString(withDateFormat: .custom("HH:mm")), style: .callout, color: .secondary, weight: .light)
                    }
                    
                    RefdsText(transaction.description, style: .callout, color: .secondary)
                }
                
                Spacer()
                
                RefdsIcon(.chevronRight, color: .secondary.opacity(0.5), style: .callout)
            }
        }
    }
    
    private func removeButton(for transaction: UUID) -> some View {
        RefdsButton {
            remove?(transaction)
        } label: {
            Label(
                String.localizable(by: .transactionsRemoveTransactions),
                systemImage: RefdsIconSymbol.trashFill.rawValue
            )
        }
    }
    
    private func swipeRemoveButton(for transaction: UUID) -> some View {
        RefdsButton {
            remove?(transaction)
        } label: {
            RefdsIcon(.trashFill)
        }
        .tint(.red)
    }
}

#Preview {
    List {
        TransactionSectionsView(viewData: [[TransactionRowViewDataMock()]])
    }
}
