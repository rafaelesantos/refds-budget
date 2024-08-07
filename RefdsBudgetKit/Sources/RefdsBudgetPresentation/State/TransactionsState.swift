import Foundation
import RefdsRedux
import RefdsShared
import RefdsBudgetData

public protocol TransactionsStateProtocol: RefdsReduxState {
    var date: Date { get set }
    var page: Int { get set }
    var canChangePage: Bool { get set }
    var isFilterEnable: Bool { get set }
    var isLoading: Bool { get set }
    var searchText: String { get set }
    var transactions: [[TransactionRowViewDataProtocol]] { get set }
    var categories: [String] { get set }
    var selectedCategories: Set<String> { get set }
    var tags: [String] { get set }
    var selectedTags: Set<String> { get set }
    var selectedStatus: Set<String> { get set }
    var balance: BalanceRowViewDataProtocol? { get set }
    var shareText: String? { get set }
    var share: URL? { get set }
    var paginationDaysAmount: Int { get set }
    var error: RefdsBudgetError? { get set }
}

public struct TransactionsState: TransactionsStateProtocol {
    public var date: Date
    public var page: Int
    public var canChangePage: Bool
    public var isFilterEnable: Bool
    public var isLoading: Bool
    public var searchText: String
    public var transactions: [[TransactionRowViewDataProtocol]]
    public var categories: [String]
    public var selectedCategories: Set<String> = []
    public var tags: [String]
    public var selectedTags: Set<String> = []
    public var selectedStatus: Set<String> = []
    public var balance: BalanceRowViewDataProtocol?
    public var shareText: String?
    public var share: URL?
    public var paginationDaysAmount: Int = 2
    public var error: RefdsBudgetError?
    
    public init(
        date: Date = .current,
        page: Int = 1,
        canChangePage: Bool = false,
        isFilterEnable: Bool = true,
        isLoading: Bool = true,
        searchText: String = "",
        transactions: [[TransactionRowViewDataProtocol]] = [],
        categories: [String] = [],
        tags: [String] = [],
        error: RefdsBudgetError? = nil
    ) {
        self.date = date
        self.page = page
        self.canChangePage = canChangePage
        self.isFilterEnable = isFilterEnable
        self.isLoading = isLoading
        self.searchText = searchText
        self.transactions = transactions
        self.categories = categories
        self.tags = tags
        self.error = error
    }
}
