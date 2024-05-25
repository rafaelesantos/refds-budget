import Foundation
import SwiftUI

public protocol CategoryRowViewDataProtocol {
    var categoryId: UUID { get }
    var budgetId: UUID { get }
    var icon: String { get }
    var name: String { get }
    var description: String? { get }
    var color: Color { get }
    var budget: Double { get }
    var percentage: Double { get }
    var transactionsAmount: Int { get }
    var spend: Double { get }
    var isAnimate: Bool { get set }
}

public struct CategoryRowViewData: CategoryRowViewDataProtocol {
    public var categoryId: UUID
    public var budgetId: UUID
    public var icon: String
    public var name: String
    public var description: String?
    public var color: Color
    public var budget: Double
    public var percentage: Double
    public var transactionsAmount: Int
    public var spend: Double
    public var isAnimate: Bool = false
    
    public init(
        categoryId: UUID,
        budgetId: UUID,
        icon: String,
        name: String,
        description: String?,
        color: Color,
        budget: Double,
        percentage: Double,
        transactionsAmount: Int,
        spend: Double
    ) {
        self.categoryId = categoryId
        self.budgetId = budgetId
        self.icon = icon
        self.name = name
        self.description = description
        self.color = color
        self.budget = budget
        self.percentage = percentage
        self.transactionsAmount = transactionsAmount
        self.spend = spend
    }
}
