import Foundation
import SwiftUI
import RefdsShared
import RefdsBudgetDomain

public protocol BudgetAdapterProtocol {
    func adapt(
        model: BudgetModelProtocol?,
        category: AddCategoryStateProtocol?,
        categories: [AddCategoryStateProtocol]
    ) -> AddBudgetStateProtocol
}

public final class BudgetAdapter: BudgetAdapterProtocol {
    public init() {}
    
    public func adapt(
        model: BudgetModelProtocol?,
        category: AddCategoryStateProtocol?,
        categories: [AddCategoryStateProtocol]
    ) -> AddBudgetStateProtocol {
        AddBudgetState(
            id: model?.id ?? .init(),
            amount: model?.amount ?? .zero,
            description: model?.message ?? "",
            month: model?.date.date ?? .current,
            category: category,
            categories: categories,
            error: nil
        )
    }
}
