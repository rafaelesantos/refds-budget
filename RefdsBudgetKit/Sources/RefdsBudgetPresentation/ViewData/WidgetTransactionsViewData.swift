import Foundation

public protocol WidgetTransactionsViewDataProtocol {
    var isFilterByDate: Bool { get set }
    var category: String { get set }
    var tag: String { get set }
    var date: Date { get set }
    var spend: Double { get set }
    var budget: Double { get set }
    var status: String { get set }
    var categories: [CategoryRowViewDataProtocol] { get set }
    var transactions: [TransactionRowViewDataProtocol] { get set }
    var amount: Int { get set }
    var percent: Double { get }
}

public struct WidgetTransactionsViewData: WidgetTransactionsViewDataProtocol {
    public var isFilterByDate: Bool
    public var category: String
    public var tag: String
    public var status: String
    public var date: Date
    public var spend: Double
    public var budget: Double
    public var categories: [CategoryRowViewDataProtocol]
    public var transactions: [TransactionRowViewDataProtocol]
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
        categories: [CategoryRowViewDataProtocol],
        transactions: [TransactionRowViewDataProtocol],
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
