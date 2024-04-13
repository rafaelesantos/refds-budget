import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class AddBudgetMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var categoryAdapter: CategoryAdapterProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { _, action, completion in
        switch action {
        case let action as AddBudgetAction: self.handler(for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        for action: AddBudgetAction,
        on completion: @escaping (AddBudgetAction) -> Void
    ) {
        switch action {
        case let .fetchCategories(date): fetchCategories(from: date, on: completion)
        case let .fetchBudget(date, id): fetchBudget(from: date, by: id, on: completion)
        case let .save(budget): save(budget, on: completion)
        default: break
        }
    }
    
    private func fetchCategories(
        from date: Date,
        on completion: @escaping (AddBudgetAction) -> Void
    ) {
        let categories = categoryRepository.getAllCategories().map { entity in
            categoryAdapter.adapt(entity: entity)
        }
        
        guard let category = categories.first,
              let budget = categoryRepository.getBudget(on: category.id, from: date) else {
            return completion(.updateCategories(categories, .init(), .zero, ""))
        }
        
        completion(.updateCategories(categories, budget.id, budget.amount, budget.message ?? ""))
    }
    
    private func fetchBudget(
        from date: Date,
        by id: UUID,
        on completion: @escaping (AddBudgetAction) -> Void
    ) {
        guard let budget = categoryRepository.getBudget(on: id, from: date) else {
            return completion(.updateBudget(.init(), .zero, ""))
        }
        
        completion(.updateBudget(budget.id, budget.amount, budget.message ?? ""))
    }
    
    private func save(
        _ budget: BudgetStateProtocol,
        on completion: @escaping (AddBudgetAction) -> Void
    ) {
        guard let category = budget.category else {
            return completion(.updateError(.notFoundCategory))
        }
        
        do {
            try categoryRepository.addBudget(
                id: budget.id,
                amount: budget.amount,
                date: budget.month,
                message: budget.description,
                category: category.id
            )
        } catch { return completion(.updateError(.existingBudget)) }
        
        guard let category = categoryRepository.getCategory(by: category.id) else {
            return completion(.updateError(.notFoundCategory))
        }
        
        do {
            try categoryRepository.addCategory(
                id: category.id,
                name: category.name.capitalized,
                color: Color(hex: category.color),
                budgets: category.budgets + [budget.id],
                icon: category.icon
            )
        } catch { return completion(.updateError(.existingCategory)) }
        
        completion(.dismiss)
    }
}
