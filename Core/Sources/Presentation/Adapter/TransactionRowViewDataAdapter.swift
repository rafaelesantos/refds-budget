import Foundation
import SwiftUI
import RefdsShared
import Domain

public protocol TransactionItemViewDataAdapterProtocol {
    func adapt(
        model: TransactionModelProtocol,
        categoryModel: CategoryModelProtocol
    ) -> TransactionItemViewDataProtocol
}

public final class TransactionItemViewDataAdapter: TransactionItemViewDataAdapterProtocol {
    public init () {}
    
    public func adapt(
        model: TransactionModelProtocol,
        categoryModel: CategoryModelProtocol
    ) -> TransactionItemViewDataProtocol {
        TransactionItemViewData(
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
