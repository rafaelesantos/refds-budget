import Foundation
import RefdsBudgetResource

public struct SystemSmallTransactionsViewDataMock: SystemSmallTransactionsViewDataProtocol {
    public var isFilterByDate: Bool = true
    public var category: String = .localizable(by: .transactionsCategorieAllSelected)
    public var tag: String = .localizable(by: .transactionsCategorieAllSelected)
    public var date: Date = .random
    public var spend: Double = .random(in: 250 ... 2500)
    public var transactions: [TransactionRowViewDataProtocol] = (1 ... 10).map { _ in TransactionRowViewDataMock() }
    public var amount: Int = .random(in: 10 ... 1000)
    
    public init() {}
}
