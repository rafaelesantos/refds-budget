import Foundation

public protocol PendingClearedViewDataProtocol {
    var pendingAmount: Double { get set }
    var clearedAmount: Double { get set }
    var pendingCount: Int { get set }
    var clearedCount: Int { get set }
    var total: Double { get }
}
