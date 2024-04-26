import Foundation
import RefdsRedux
import RefdsBudgetData

public protocol HomeStateProtocol: RefdsReduxState {
    var balance: BalanceRowViewDataProtocol? { get set }
    var remainingBalance: BalanceRowViewDataProtocol? { get set }
    var remaining: [CategoryRowViewDataProtocol] { get set }
    var tagsRow: [TagRowViewDataProtocol] { get set }
    var largestPurchase: [TransactionRowViewDataProtocol] { get set }
    var categories: [String] { get set }
    var selectedCategories: Set<String> { get set }
    var tags: [String] { get set }
    var selectedTags: Set<String> { get set }
    var isFilterEnable: Bool { get set }
    var date: Date { get set }
    var error: RefdsBudgetError? { get set }
}

public struct HomeState: HomeStateProtocol {
    public var balance: BalanceRowViewDataProtocol?
    public var remainingBalance: BalanceRowViewDataProtocol?
    public var remaining: [CategoryRowViewDataProtocol] = []
    public var tagsRow: [TagRowViewDataProtocol] = []
    public var largestPurchase: [TransactionRowViewDataProtocol] = []
    
    public var categories: [String] = []
    public var selectedCategories: Set<String> = []
    public var tags: [String] = []
    public var selectedTags: Set<String> = []
    
    public var isFilterEnable: Bool = true
    public var date: Date = .current
    public var error: RefdsBudgetError?
    
    public init() {}
}
