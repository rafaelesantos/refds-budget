import Foundation
import Domain

struct HomeState: HomeStateProtocol {
    var isLoading: Bool
    var filter: FilterViewDataProtocol
    var balance: BalanceViewDataProtocol?
    var remainingBalance: BalanceViewDataProtocol?
    var remaining: [CategoryItemViewDataProtocol]
    var tagsRow: [TagItemViewDataProtocol]
    var largestPurchase: [TransactionItemViewDataProtocol]
    var pendingCleared: PendingClearedViewDataProtocol?
    var selectedTag: TagItemViewDataProtocol?
    var selectedRemaining: CategoryItemViewDataProtocol?
    var error: RefdsBudgetError?
    
    init(
        isLoading: Bool = true,
        filter: FilterViewDataProtocol = FilterViewData(items: [.date, .categories([]), .tags([]), .status([])]),
        balance: BalanceViewDataProtocol? = nil,
        remainingBalance: BalanceViewDataProtocol? = nil,
        remaining: [CategoryItemViewDataProtocol] = [],
        tagsRow: [TagItemViewDataProtocol] = [],
        largestPurchase: [TransactionItemViewDataProtocol] = [],
        pendingCleared: PendingClearedViewDataProtocol? = nil,
        selectedTag: TagItemViewDataProtocol? = nil,
        selectedRemaining: CategoryItemViewDataProtocol? = nil,
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
