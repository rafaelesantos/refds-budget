import Foundation
import Domain

public struct HomeStateMock: HomeStateProtocol {
    public var isLoading: Bool = true
    public var filter: FilterViewDataProtocol = FilterViewDataMock()
    public var balance: BalanceViewDataProtocol? = BalanceViewDataMock()
    public var remainingBalance: BalanceViewDataProtocol? = BalanceViewDataMock()
    public var remaining: [CategoryItemViewDataProtocol] = (1 ... 5).map { _ in CategoryItemViewDataMock() }
    public var tagsRow: [TagItemViewDataProtocol] = (1 ... 5).map { _ in TagItemViewDataMock() }
    public var largestPurchase: [TransactionItemViewDataProtocol] = (1 ... 5).map { _ in TransactionItemViewDataMock() }
    public var pendingCleared: PendingClearedViewDataProtocol? = PendingClearedViewDataMock()
    public var selectedTag: TagItemViewDataProtocol?
    public var selectedRemaining: CategoryItemViewDataProtocol?
    public var error: RefdsBudgetError? = nil
    
    public init() {}
}
