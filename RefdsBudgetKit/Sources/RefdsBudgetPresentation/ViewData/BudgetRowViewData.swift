import Foundation
import SwiftUI

public protocol BudgetRowViewDataProtocol {
    var id: UUID { get }
    var date: Date { get }
    var description: String? { get }
    var amount: Double { get }
    var spend: Double { get }
    var percentage: Double { get }
    var isSelected: Bool { get set }
}

public struct BudgetRowViewData: BudgetRowViewDataProtocol {
    public var id: UUID
    public var date: Date
    public var description: String?
    public var amount: Double
    public var spend: Double
    public var percentage: Double
    public var isSelected: Bool = false
    
    init(
        id: UUID,
        date: Date,
        description: String? = nil,
        amount: Double,
        spend: Double,
        percentage: Double
    ) {
        self.id = id
        self.date = date
        self.description = description
        self.amount = amount
        self.spend = spend
        self.percentage = percentage
    }
}
