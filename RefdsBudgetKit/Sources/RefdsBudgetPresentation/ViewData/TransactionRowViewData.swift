import Foundation
import SwiftUI
import RefdsBudgetDomain

public protocol TransactionRowViewDataProtocol {
    var id: UUID { get }
    var icon: String { get }
    var color: Color { get }
    var amount: Double { get }
    var description: String { get }
    var date: Date { get }
    var status: TransactionStatus { get }
}

public struct TransactionRowViewData: TransactionRowViewDataProtocol {
    public var id: UUID
    public var icon: String
    public var color: Color
    public var amount: Double
    public var description: String
    public var date: Date
    public var status: TransactionStatus
    
    public init(
        id: UUID,
        icon: String,
        color: Color,
        amount: Double,
        description: String,
        date: Date,
        status: TransactionStatus
    ) {
        self.id = id
        self.icon = icon
        self.color = color
        self.amount = amount
        self.description = description
        self.date = date
        self.status = status
    }
}
