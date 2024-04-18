import Foundation
import SwiftUI
import RefdsShared
import RefdsBudgetDomain

public protocol CategoryAdapterProtocol {
    func adapt(entity: CategoryEntity) -> AddCategoryStateProtocol
    func adapt(
        entity: CategoryEntity,
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
    
    public func adapt(entity: CategoryEntity) -> AddCategoryStateProtocol {
        AddCategoryState(
            id: entity.id,
            name: entity.name,
            color: Color(hex: entity.color),
            icon: entity.icon
        )
    }
    
    public func adapt(
        entity: CategoryEntity,
        budgetId: UUID,
        budgetDescription: String?,
        budget: Double,
        percentage: Double,
        transactionsAmount: Int,
        spend: Double
    ) -> CategoryRowViewDataProtocol {
        CategoryRowViewData(
            categoryId: entity.id,
            budgetId: budgetId,
            icon: entity.icon,
            name: entity.name,
            description: budgetDescription,
            color: Color(hex: entity.color),
            budget: budget,
            percentage: percentage,
            transactionsAmount: transactionsAmount,
            spend: spend
        )
    }
}
