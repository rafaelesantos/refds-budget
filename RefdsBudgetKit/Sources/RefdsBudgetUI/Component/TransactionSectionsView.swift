import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetDomain
import RefdsBudgetResource
import RefdsBudgetPresentation

public struct TransactionSectionsView: View {
    @Environment(\.privacyMode) private var privacyMode
    private let viewData: [[TransactionRowViewDataProtocol]]
    private let action: ((TransactionRowViewDataProtocol) -> Void)?
    private let remove: ((UUID) -> Void)?
    private let resolve: ((UUID) -> Void)?
    
    public init(
        viewData: [[TransactionRowViewDataProtocol]],
        action: ((TransactionRowViewDataProtocol) -> Void)? = nil,
        remove: ((UUID) -> Void)? = nil,
        resolve: ((UUID) -> Void)? = nil
    ) {
        self.viewData = viewData
        self.action = action
        self.remove = remove
        self.resolve = resolve
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
                if index == 1 {
                    sectionChart
                }
                RefdsSection {
                    ForEach(transactions.indices, id: \.self) { index in
                        let transaction = transactions[index]
                        RefdsButton { action?(transaction) } label: {
                            transactionRow(transaction)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            if transaction.status == .pending || transaction.status == .cleared {
                                swipeResolveButton(for: transaction)
                            }
                            swipeRemoveButton(for: transaction.id)
                        }
                        .contextMenu {
                            removeButton(for: transaction.id)
                            if transaction.status == .pending || transaction.status == .cleared {
                                resolveButton(for: transaction)
                            }
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
                ZStack(alignment: .bottomTrailing) {
                    RefdsIcon(
                        icon,
                        color: transaction.color,
                        size: .padding(.medium)
                    )
                    .frame(width: .padding(.medium), height: .padding(.medium))
                    .padding(10)
                    .background(transaction.color.opacity(0.2))
                    .clipShape(.rect(cornerRadius: .cornerRadius))
                    
                    if let icon = transaction.status.icon {
                        RefdsIcon(
                            icon,
                            color: transaction.status.color,
                            size: .padding(.medium)
                        )
                        .padding(-8)
                        .background()
                    }
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: .padding(.small)) {
                        RefdsText(transaction.amount.currency(), style: .callout, color: transaction.status.color, lineLimit: 1)
                            .refdsRedacted(if: privacyMode)
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
    
    @ViewBuilder
    private func resolveButton(for transaction: TransactionRowViewDataProtocol) -> some View {
        let status: TransactionStatus = transaction.status == .pending ? .cleared : .pending
        RefdsButton {
            remove?(transaction.id)
        } label: {
            Label(
                status.description,
                systemImage: (status.icon ?? .checkmark).rawValue
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
    
    @ViewBuilder
    private func swipeResolveButton(for transaction: TransactionRowViewDataProtocol) -> some View {
        let status: TransactionStatus = transaction.status == .pending ? .cleared : .pending
        RefdsButton {
            resolve?(transaction.id)
        } label: {
            RefdsIcon(status.icon ?? .checkmark)
        }
        .tint(status.color)
    }
    
    @ViewBuilder
    private var sectionChart: some View {
        if viewData.count > 1 {
            let data: [(x: Date, y: Double, percentage: Double?)] = viewData.reversed().map {
                let date = $0.first?.date ?? .current
                let amount = $0.map { $0.amount }.reduce(.zero, +)
                return (
                    x: date,
                    y: amount,
                    percentage: nil
                )
            }
            DateChartView(data: data, format: .custom("EEEE dd, MMMM yyyy"))
        }
    }
}

#Preview {
    List {
        TransactionSectionsView(viewData: [[TransactionRowViewDataMock()]])
    }
}
