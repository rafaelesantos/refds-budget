import Foundation
import SwiftUI
import RefdsShared
import RefdsBudgetDomain

public protocol BudgetRowViewDataAdapterProtocol {
    func adapt(budgetEntity: BudgetEntity, percentage: Double) -> BudgetRowViewDataProtocol
}

public final class BudgetRowViewDataAdapter: BudgetRowViewDataAdapterProtocol {
    public init () {}
    
    public func adapt(budgetEntity: BudgetEntity, percentage: Double) -> BudgetRowViewDataProtocol {
        BudgetRowViewData(
            id: budgetEntity.id,
            date: budgetEntity.date.date,
            description: budgetEntity.message,
            amount: budgetEntity.amount,
            percentage: percentage
        )
    }
}
