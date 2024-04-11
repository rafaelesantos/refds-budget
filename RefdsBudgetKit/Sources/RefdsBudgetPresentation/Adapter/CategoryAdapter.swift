import Foundation
import SwiftUI
import RefdsShared
import RefdsBudgetDomain

public protocol CategoryAdapterProtocol {
    func adaptCategory(entity: CategoryEntity) -> CategoryStateProtocol
    func adapt(budget: BudgetEntity, categories: [CategoryEntity]) -> BudgetStateProtocol
}

public final class CategoryAdapter: CategoryAdapterProtocol {
    public init() {}
    
    public func adaptCategory(entity: CategoryEntity) -> CategoryStateProtocol {
        AddCategoryState(
            id: entity.id,
            name: entity.name,
            color: Color(hex: entity.color),
            icon: entity.icon
        )
    }
    
    public func adapt(budget: BudgetEntity, categories: [CategoryEntity]) -> BudgetStateProtocol {
        let categories = categories.map { adaptCategory(entity: $0) }
        return AddBudgetState(
            id: budget.id,
            amount: budget.amount,
            description: budget.message ?? "",
            month: budget.date.date,
            category: categories.first,
            categories: categories
        )
    }
}
