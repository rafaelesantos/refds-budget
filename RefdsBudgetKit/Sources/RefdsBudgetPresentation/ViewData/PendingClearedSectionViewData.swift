import Foundation

public protocol PendingClearedSectionViewDataProtocol {
    var pendingAmount: Double { get set }
    var clearedAmount: Double { get set }
    var pendingCount: Int { get set }
    var clearedCount: Int { get set }
    var total: Double { get }
}

public struct PendingClearedSectionViewData: PendingClearedSectionViewDataProtocol {
    public var pendingAmount: Double
    public var clearedAmount: Double
    public var pendingCount: Int
    public var clearedCount: Int
    
    public var total: Double {
        (pendingAmount + clearedAmount) == .zero ? 1 : (pendingAmount + clearedAmount)
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
