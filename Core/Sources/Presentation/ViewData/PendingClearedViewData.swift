import Foundation
import Domain

public struct PendingClearedViewData: PendingClearedViewDataProtocol {
    public var pendingAmount: Double
    public var clearedAmount: Double
    public var pendingCount: Int
    public var clearedCount: Int
    
    public var total: Double {
        (pendingAmount + clearedAmount) == .zero ?
        1 : (pendingAmount + clearedAmount)
    }
    
    public init(
        pendingAmount: Double,
        clearedAmount: Double,
        pendingCount: Int,
        clearedCount: Int
    ) {
        self.pendingAmount = pendingAmount
        self.clearedAmount = clearedAmount
        self.pendingCount = pendingCount
        self.clearedCount = clearedCount
    }
}
