import Foundation
import SwiftUI

public struct TransactionRowViewData {
    public let icon: String
    public let color: Color
    public let amount: Double
    public let description: String
    public let date: Date
    
    public init(
        icon: String,
        color: Color,
        amount: Double,
        description: String,
        date: Date
    ) {
        self.icon = icon
        self.color = color
        self.amount = amount
        self.description = description
        self.date = date
    }
}
