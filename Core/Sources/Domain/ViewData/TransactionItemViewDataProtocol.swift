import SwiftUI

public protocol TransactionItemViewDataProtocol {
    var id: UUID { get }
    var icon: String { get }
    var color: Color { get }
    var amount: Double { get }
    var description: String { get }
    var date: Date { get }
    var status: TransactionStatus { get }
}
