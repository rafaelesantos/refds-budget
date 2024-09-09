import SwiftUI
import RefdsRedux
import RefdsBudgetDomain
import RefdsBudgetData

public protocol HomeStateProtocol: RefdsReduxState {
    var isLoading: Bool { get set }
    var filter: FilterViewDataProtocol { get set }
    var balance: BalanceRowViewDataProtocol? { get set }
    var remainingBalance: BalanceRowViewDataProtocol? { get set }
    var remaining: [CategoryRowViewDataProtocol] { get set }
    var tagsRow: [TagRowViewDataProtocol] { get set }
    var largestPurchase: [TransactionRowViewDataProtocol] { get set }
    var pendingCleared: PendingClearedSectionViewDataProtocol? { get set }
    var selectedTag: TagRowViewDataProtocol? { get set }
    var selectedRemaining: CategoryRowViewDataProtocol? { get set }
    var error: RefdsBudgetError? { get set }
}

public struct HomeState: HomeStateProtocol {
    public var isLoading: Bool
    public var filter: FilterViewDataProtocol
    public var balance: BalanceRowViewDataProtocol?
    public var remainingBalance: BalanceRowViewDataProtocol?
    public var remaining: [CategoryRowViewDataProtocol]
    public var tagsRow: [TagRowViewDataProtocol]
    public var largestPurchase: [TransactionRowViewDataProtocol]
    public var pendingCleared: PendingClearedSectionViewDataProtocol?
    public var selectedTag: TagRowViewDataProtocol?
    public var selectedRemaining: CategoryRowViewDataProtocol?
    public var error: RefdsBudgetError?
    
    public init(
        isLoading: Bool = true,
        filter: FilterViewDataProtocol = FilterViewData(items: [.date, .categories([]), .tags([]), .status([])]),
        balance: BalanceRowViewDataProtocol? = nil,
        remainingBalance: BalanceRowViewDataProtocol? = nil,
        remaining: [CategoryRowViewDataProtocol] = [],
        tagsRow: [TagRowViewDataProtocol] = [],
        largestPurchase: [TransactionRowViewDataProtocol] = [],
        pendingCleared: PendingClearedSectionViewDataProtocol? = nil,
        selectedTag: TagRowViewDataProtocol? = nil,
        selectedRemaining: CategoryRowViewDataProtocol? = nil,
        error: RefdsBudgetError? = nil
    ) {
        self.isLoading = isLoading
        self.filter = filter
        self.balance = balance
        self.remainingBalance = remainingBalance
        self.remaining = remaining
        self.tagsRow = tagsRow
        self.largestPurchase = largestPurchase
        self.pendingCleared = pendingCleared
        self.selectedTag = selectedTag
        self.selectedRemaining = selectedRemaining
        self.error = error
    }
}
