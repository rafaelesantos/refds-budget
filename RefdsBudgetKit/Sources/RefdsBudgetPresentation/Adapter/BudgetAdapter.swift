import Foundation
import SwiftUI
import RefdsShared
import RefdsBudgetDomain

public protocol BudgetAdapterProtocol {
    func adapt(
        entity: BudgetEntity?,
        category: AddCategoryStateProtocol?,
        categories: [AddCategoryStateProtocol]
    ) -> AddBudgetStateProtocol
}

public final class BudgetAdapter: BudgetAdapterProtocol {
    public init() {}
    
    public func adapt(
        entity: BudgetEntity?,
        category: AddCategoryStateProtocol?,
        categories: [AddCategoryStateProtocol]
    ) -> AddBudgetStateProtocol {
        AddBudgetState(
            id: entity?.id ?? .init(),
            amount: entity?.amount ?? .zero,
            description: entity?.message ?? "",
            month: entity?.date.date ?? .current,
            category: category,
            categories: categories,
            error: nil
        )
    }
}
