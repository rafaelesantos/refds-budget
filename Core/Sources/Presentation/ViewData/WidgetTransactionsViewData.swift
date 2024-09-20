import Foundation
import Domain

public struct WidgetTransactionsViewData: WidgetTransactionsViewDataProtocol {
    public var isFilterByDate: Bool
    public var category: String
    public var tag: String
    public var status: String
    public var date: Date
    public var spend: Double
    public var budget: Double
    public var categories: [CategoryItemViewDataProtocol]
    public var transactions: [TransactionItemViewDataProtocol]
    public var amount: Int
    
    public var percent: Double {
        spend / (budget == .zero ? 1 : budget)
    }
    
    public init(
        isFilterByDate: Bool,
        category: String,
        tag: String,
        status: String,
        date: Date,
        spend: Double,
        budget: Double,
        categories: [CategoryItemViewDataProtocol],
        transactions: [TransactionItemViewDataProtocol],
        amount: Int
    ) {
        self.isFilterByDate = isFilterByDate
        self.category = category
        self.tag = tag
        self.status = status
        self.date = date
        self.spend = spend
        self.budget = budget
        self.categories = categories
        self.transactions = transactions
        self.amount = amount
    }
}
