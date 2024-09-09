import SwiftUI
import RefdsBudgetDomain
import RefdsBudgetMock

public struct HomeStateMock: HomeStateProtocol {
    public var isLoading: Bool = true
    public var filter: FilterViewDataProtocol = FilterViewDataMock()
    public var balance: BalanceRowViewDataProtocol? = BalanceRowViewDataMock()
    public var remainingBalance: BalanceRowViewDataProtocol? = BalanceRowViewDataMock()
    public var remaining: [CategoryRowViewDataProtocol] = (1 ... 5).map { _ in CategoryRowViewDataMock() }
    public var tagsRow: [TagRowViewDataProtocol] = (1 ... 5).map { _ in TagRowViewDataMock() }
    public var largestPurchase: [TransactionRowViewDataProtocol] = (1 ... 5).map { _ in TransactionRowViewDataMock() }
    public var pendingCleared: PendingClearedSectionViewDataProtocol? = PendingClearedSectionViewDataMock()
    public var selectedTag: TagRowViewDataProtocol?
    public var selectedRemaining: CategoryRowViewDataProtocol?
    public var error: RefdsBudgetError? = nil
    
    public init() {}
}
