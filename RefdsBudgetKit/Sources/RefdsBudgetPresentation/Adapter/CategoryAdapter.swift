import Foundation
import SwiftUI
import RefdsShared
import RefdsBudgetDomain

public protocol CategoryAdapterProtocol {
    func adapt(model: CategoryModelProtocol) -> AddCategoryStateProtocol
    func adapt(
        model: CategoryModelProtocol,
        budgetId: UUID,
        budgetDescription: String?,
        budget: Double,
        percentage: Double,
        transactionsAmount: Int,
        spend: Double
    ) -> CategoryRowViewDataProtocol
}

public final class CategoryAdapter: CategoryAdapterProtocol {
    public init() {}
    
    public func adapt(model: CategoryModelProtocol) -> AddCategoryStateProtocol {
        AddCategoryState(
            id: model.id,
            name: model.name,
            color: Color(hex: model.color),
            icon: model.icon
        )
    }
    
    public func adapt(
        model: CategoryModelProtocol,
        budgetId: UUID,
        budgetDescription: String?,
        budget: Double,
        percentage: Double,
        transactionsAmount: Int,
        spend: Double
    ) -> CategoryRowViewDataProtocol {
        CategoryRowViewData(
            categoryId: model.id,
            budgetId: budgetId,
            icon: model.icon,
            name: model.name,
            description: budgetDescription,
            color: Color(hex: model.color),
            budget: budget,
            percentage: percentage,
            transactionsAmount: transactionsAmount,
            spend: spend
        )
    }
}
