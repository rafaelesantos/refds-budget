import Foundation
import SwiftUI
import RefdsShared
import RefdsBudgetDomain

public protocol TransactionRowViewDataAdapterProtocol {
    func adapt(
        transactionEntity: TransactionEntity,
        categoryEntity: CategoryEntity
    ) -> TransactionRowViewDataProtocol
}

public final class TransactionRowViewDataAdapter: TransactionRowViewDataAdapterProtocol {
    public init () {}
    
    public func adapt(
        transactionEntity: TransactionEntity,
        categoryEntity: CategoryEntity
    ) -> TransactionRowViewDataProtocol {
        TransactionRowViewData(
            id: transactionEntity.id,
            icon: categoryEntity.icon,
            color: Color(hex: categoryEntity.color),
            amount: transactionEntity.amount,
            description: transactionEntity.message,
            date: transactionEntity.date.date,
            status: TransactionStatus(rawValue: transactionEntity.status) ?? .spend
        )
    }
}
