import Foundation

public struct PendingClearedSectionViewDataMock: PendingClearedSectionViewDataProtocol {
    public var pendingAmount: Double = .random(in: 300 ... 700)
    public var clearedAmount: Double = .random(in: 300 ... 700)
    public var pendingCount: Int = .random(in: 5 ... 30)
    public var clearedCount: Int = .random(in: 5 ... 30)
    
    public var total: Double {
        (pendingAmount + clearedAmount) == .zero ? 1 : (pendingAmount + clearedAmount)
    }
    
    public init() {}
}
