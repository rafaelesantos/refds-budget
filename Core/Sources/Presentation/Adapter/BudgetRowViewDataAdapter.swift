import Foundation
import SwiftUI
import RefdsShared
import Domain

public protocol BudgetItemViewDataAdapterProtocol {
    func adapt(
        model: BudgetModelProtocol,
        spend: Double,
        percentage: Double
    ) -> BudgetItemViewDataProtocol
}

public final class BudgetItemViewDataAdapter: BudgetItemViewDataAdapterProtocol {
    public init () {}
    
    public func adapt(
        model: BudgetModelProtocol,
        spend: Double,
        percentage: Double
    ) -> BudgetItemViewDataProtocol {
        BudgetItemViewData(
            id: model.id,
            date: model.date.date,
            description: model.message,
            amount: model.amount,
            spend: spend,
            percentage: percentage
        )
    }
}
