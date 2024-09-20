import SwiftUI
import RefdsUI
import RefdsShared
import Mock
import Domain
import Resource
import Presentation

struct TransactionSectionsView: View {
    @Environment(\.privacyMode) private var privacyMode
    
    private let viewData: [[TransactionItemViewDataProtocol]]
    private let isLoading: Bool
    private let action: ((TransactionItemViewDataProtocol) -> Void)?
    private let remove: ((UUID) -> Void)?
    private let resolve: ((UUID) -> Void)?
    
    init(
        viewData: [[TransactionItemViewDataProtocol]],
        isLoading: Bool = false,
        action: ((TransactionItemViewDataProtocol) -> Void)? = nil,
        remove: ((UUID) -> Void)? = nil,
        resolve: ((UUID) -> Void)? = nil
    ) {
        self.viewData = viewData
        self.isLoading = isLoading
        self.action = action
        self.remove = remove
        self.resolve = resolve
    }
    
    @ViewBuilder
    var body: some View {
        if !viewData.isEmpty {
            ForEach(viewData.indices, id: \.self) { index in
                let transactions = viewData[index]
                
                RefdsSection {
                    ForEach(transactions.indices, id: \.self) { index in
                        let transaction = transactions[index]
                        RefdsButton { action?(transaction) } label: {
                            TransactionItemView(viewData: transaction)
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
                } footer: {
                    if !transactions.isEmpty {
                        HStack {
                            let total = transactions.filter { $0.status != .cleared }.map { $0.amount }.reduce(.zero, +)
                            RefdsText(
                                .localizable(by: .homeRemainingCategoryTransactions, with: transactions.count).uppercased(),
                                style: .footnote,
                                color: .secondary
                            )
                            Spacer()
                            RefdsText(
                                total.currency().uppercased(),
                                style: .footnote,
                                color: .secondary
                            )
                            .refdsRedacted(if: privacyMode)
                        }
                    }
                }
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
    private func resolveButton(for transaction: TransactionItemViewDataProtocol) -> some View {
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
    private func swipeResolveButton(for transaction: TransactionItemViewDataProtocol) -> some View {
        let status: TransactionStatus = transaction.status == .pending ? .cleared : .pending
        RefdsButton {
            resolve?(transaction.id)
        } label: {
            RefdsIcon(status.icon ?? .checkmark)
        }
        .tint(status.color)
    }
}

#Preview {
    List {
        TransactionSectionsView(viewData: [[TransactionItemViewDataMock()]])
    }
}
