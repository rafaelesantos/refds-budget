import Foundation
import SwiftUI
import RefdsShared
import RefdsBudgetDomain

public protocol TransactionRowViewDataAdapterProtocol {
    func adapt(
        model: TransactionModelProtocol,
        categoryModel: CategoryModelProtocol
    ) -> TransactionRowViewDataProtocol
}

public final class TransactionRowViewDataAdapter: TransactionRowViewDataAdapterProtocol {
    public init () {}
    
    public func adapt(
        model: TransactionModelProtocol,
        categoryModel: CategoryModelProtocol
    ) -> TransactionRowViewDataProtocol {
        TransactionRowViewData(
            id: model.id,
            icon: categoryModel.icon,
            color: Color(hex: categoryModel.color),
            amount: model.amount,
            description: model.message,
            date: model.date.date,
            status: TransactionStatus(rawValue: model.status) ?? .spend
        )
    }
}
