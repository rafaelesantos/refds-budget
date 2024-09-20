import SwiftUI
import Domain

struct TransactionItemViewData: TransactionItemViewDataProtocol {
    var id: UUID
    var icon: String
    var color: Color
    var amount: Double
    var description: String
    var date: Date
    var status: TransactionStatus
    
    init(
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
