import Foundation
import SwiftUI

public protocol BudgetRowViewDataProtocol {
    var id: UUID { get }
    var date: Date { get }
    var description: String? { get }
    var amount: Double { get set }
    var spend: Double { get set }
    var percentage: Double { get set }
    var isSelected: Bool { get set }
    var hasAI: Bool { get set }
}

public struct BudgetRowViewData: BudgetRowViewDataProtocol {
    public var id: UUID
    public var date: Date
    public var description: String?
    public var amount: Double
    public var spend: Double
    public var percentage: Double
    public var isSelected: Bool = false
    public var hasAI: Bool = false
    
    init(
        id: UUID,
        date: Date,
        description: String? = nil,
        amount: Double,
        spend: Double,
        percentage: Double,
        isSelected: Bool = false,
        hasAI: Bool = false
    ) {
        self.id = id
        self.date = date
        self.description = description
        self.amount = amount
        self.spend = spend
        self.percentage = percentage
        self.isSelected = isSelected
        self.hasAI = hasAI
    }
}
