import Foundation
import RefdsBudgetData

public struct HomeStateMock: HomeStateProtocol {
    public var isLoading: Bool = true
    public var balance: BalanceRowViewDataProtocol? = BalanceRowViewDataMock()
    public var remainingBalance: BalanceRowViewDataProtocol? = BalanceRowViewDataMock()
    public var remaining: [CategoryRowViewDataProtocol] = (1 ... 5).map { _ in CategoryRowViewDataMock() }
    public var tagsRow: [TagRowViewDataProtocol] = (1 ... 5).map { _ in TagRowViewDataMock() }
    public var largestPurchase: [TransactionRowViewDataProtocol] = (1 ... 5).map { _ in TransactionRowViewDataMock() }
    
    
    public var categories: [String] = (1 ... 5).map { _ in CategoryRowViewDataMock().name }
    public var selectedCategories: Set<String> = []
    public var tags: [String] = (1 ... 5).map { _ in TagRowViewDataMock().name }
    public var selectedTags: Set<String> = []
    
    public var isFilterEnable: Bool = true
    public var date: Date = .current
    public var error: RefdsBudgetError? = nil
    
    public init() {}
}
