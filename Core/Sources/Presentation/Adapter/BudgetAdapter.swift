import Foundation
import SwiftUI
import RefdsShared
import Domain

public protocol BudgetAdapterProtocol {
    func adapt(
        model: BudgetModelProtocol?,
        category: CategoryItemViewDataProtocol?,
        categories: [CategoryItemViewDataProtocol]
    ) -> AddBudgetStateProtocol
}

public final class BudgetAdapter: BudgetAdapterProtocol {
    public init() {}
    
    public func adapt(
        model: BudgetModelProtocol?,
        category: CategoryItemViewDataProtocol?,
        categories: [CategoryItemViewDataProtocol]
    ) -> AddBudgetStateProtocol {
        AddBudgetState(
            id: model?.id ?? .init(),
            amount: model?.amount ?? .zero,
            description: model?.message ?? "",
            date: model?.date.date ?? .current,
            category: category,
            categories: categories,
            error: nil
        )
    }
}
