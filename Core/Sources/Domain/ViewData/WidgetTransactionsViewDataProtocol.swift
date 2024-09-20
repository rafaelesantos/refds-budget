import Foundation

public protocol WidgetTransactionsViewDataProtocol {
    var isFilterByDate: Bool { get set }
    var category: String { get set }
    var tag: String { get set }
    var date: Date { get set }
    var spend: Double { get set }
    var budget: Double { get set }
    var status: String { get set }
    var categories: [CategoryItemViewDataProtocol] { get set }
    var transactions: [TransactionItemViewDataProtocol] { get set }
    var amount: Int { get set }
    var percent: Double { get }
}
