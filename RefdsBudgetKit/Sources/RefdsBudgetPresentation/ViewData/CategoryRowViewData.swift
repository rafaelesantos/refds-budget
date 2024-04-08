import Foundation
import SwiftUI

public struct CategoryRowViewData {
    public let icon: String
    public let name: String
    public let description: String?
    public let color: Color
    public let budget: Double
    public let percentage: Double
    public let transactionsAmount: Int
    public let spend: Double
    
    public init(
        icon: String,
        name: String,
        description: String?,
        color: Color,
        budget: Double,
        percentage: Double,
        transactionsAmount: Int,
        spend: Double
    ) {
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
