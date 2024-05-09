import Foundation
import RefdsBudgetResource
import RefdsBudgetDomain

public struct WidgetTransactionsViewDataMock: WidgetTransactionsViewDataProtocol {
    public var isFilterByDate: Bool = true
    public var category: String = .localizable(by: .transactionsCategorieAllSelected)
    public var tag: String = .localizable(by: .transactionsCategorieAllSelected)
    public var status: String = TransactionStatus.pending.description
    public var date: Date = .random
    public var spend: Double = .random(in: 250 ... 2500)
    public var budget: Double = .random(in: 250 ... 2500)
    public var categories: [CategoryRowViewDataProtocol] = (1 ... 6).map { _ in CategoryRowViewDataMock() }
    public var transactions: [TransactionRowViewDataProtocol] = (1 ... 10).map { _ in TransactionRowViewDataMock() }
    public var amount: Int = .random(in: 10 ... 1000)
    
    public var percent: Double {
        spend / (budget == .zero ? 1 : budget)
    }
    
    public init() {}
}
