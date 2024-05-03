import Foundation

public protocol SystemSmallTransactionsViewDataProtocol {
    var isFilterByDate: Bool { get set }
    var category: String { get set }
    var tag: String { get set }
    var date: Date { get set }
    var spend: Double { get set }
    var transactions: [TransactionRowViewDataProtocol] { get set }
    var amount: Int { get set }
}

public struct SystemSmallTransactionsViewData: SystemSmallTransactionsViewDataProtocol {
    public var isFilterByDate: Bool
    public var category: String
    public var tag: String
    public var date: Date
    public var spend: Double
    public var transactions: [TransactionRowViewDataProtocol]
    public var amount: Int
    
    public init(
        isFilterByDate: Bool,
        category: String,
        tag: String,
        date: Date,
        spend: Double,
        transactions: [TransactionRowViewDataProtocol],
        amount: Int
    ) {
        self.isFilterByDate = isFilterByDate
        self.category = category
        self.tag = tag
        self.date = date
        self.spend = spend
        self.transactions = transactions
        self.amount = amount
    }
}
