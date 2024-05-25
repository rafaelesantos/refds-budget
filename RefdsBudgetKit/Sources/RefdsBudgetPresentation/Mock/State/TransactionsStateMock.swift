import Foundation
import RefdsShared
import RefdsBudgetData

public struct TransactionsStateMock: TransactionsStateProtocol {
    public var date: Date = .current
    public var page: Int = 1
    public var canChangePage: Bool = false
    public var isFilterEnable: Bool = true
    public var isLoading: Bool = true
    public var searchText: String = ""
    public var transactions: [[TransactionRowViewDataProtocol]] = [(1 ... 5).map { _ in TransactionRowViewDataMock() }]
    public var categories: [String] = (1 ... 5).map { _ in CategoryRowViewDataMock().name }
    public var selectedCategories: Set<String> = []
    public var tags: [String] = (1 ... 5).map { _ in TagRowViewDataMock().name }
    public var selectedTags: Set<String> = []
    public var selectedStatus: Set<String> = []
    public var balance: (BalanceRowViewDataProtocol)? = BalanceRowViewDataMock()
    public var shareText: String?
    public var share: URL?
    public var error: RefdsBudgetError? = nil
    
    public init() {}
}
