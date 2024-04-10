import Foundation
import SwiftUI
import RefdsShared
import RefdsBudgetDomain

public protocol CategoryAdapterProtocol {
    func adapt(category: CategoryEntity, budgets: [BudgetEntity]) -> CategoryStateProtocol
    func adapt(budget: BudgetEntity, categories: [CategoryEntity]) -> BudgetStateProtocol
}

public final class CategoryAdapter: CategoryAdapterProtocol {
    public init() {}
    
    public func adapt(category: CategoryEntity, budgets: [BudgetEntity]) -> CategoryStateProtocol {
        AddCategoryState(
            id: category.id,
            name: category.name,
            color: Color(hex: category.color),
            icon: category.icon,
            budgets: budgets.map { adapt(budget: $0, categories: []) }
        )
    }
    
    public func adapt(budget: BudgetEntity, categories: [CategoryEntity]) -> BudgetStateProtocol {
        let categories = categories.map { adapt(category: $0, budgets: []) }
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
