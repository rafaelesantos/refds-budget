import Foundation
import SwiftUI
import RefdsShared
import RefdsBudgetDomain

public protocol BudgetRowViewDataAdapterProtocol {
    func adapt(
        model: BudgetModelProtocol,
        percentage: Double
    ) -> BudgetRowViewDataProtocol
}

public final class BudgetRowViewDataAdapter: BudgetRowViewDataAdapterProtocol {
    public init () {}
    
    public func adapt(
        model: BudgetModelProtocol,
        percentage: Double
    ) -> BudgetRowViewDataProtocol {
        BudgetRowViewData(
            id: model.id,
            date: model.date.date,
            description: model.message,
            amount: model.amount,
            percentage: percentage
        )
    }
}
