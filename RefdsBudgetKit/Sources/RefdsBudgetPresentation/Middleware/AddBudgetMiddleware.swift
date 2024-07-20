import Foundation
import SwiftUI
import WidgetKit
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class AddBudgetMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var budgetRepository: BudgetUseCase
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var categoryAdapter: CategoryAdapterProtocol
    @RefdsInjection private var intelligence: IntelligenceProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = (state as? ApplicationStateProtocol)?.addBudgetState else { return }
        switch action {
        case let action as AddBudgetAction: self.handler(with: state, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: AddBudgetStateProtocol,
        for action: AddBudgetAction,
        on completion: @escaping (AddBudgetAction) -> Void
    ) {
        switch action {
        case .fetchCategories: fetchCategories(
            with: state,
            from: state.month,
            on: completion
        )
        case .fetchBudget:
            guard let category = state.category else { return }
            fetchBudget(from: state.month, by: category.id, on: completion)
        case let .save(budget): save(budget, on: completion)
        default: break
       }
    }
    
    private func fetchCategories(
        with state: AddBudgetStateProtocol,
        from date: Date,
        on completion: @escaping (AddBudgetAction) -> Void
    ) {
        let categoryEntities: [(CategoryModelProtocol, Double)] = categoryRepository.getAllCategories().map {
            let budget = budgetRepository.getBudget(on: $0.id, from: date)?.amount ?? .zero
            return ($0, budget)
        }.sorted(by: { $0.1 < $1.1 })
        
        let categories = categoryEntities.map { $0.0 }.map { entity in
            categoryAdapter.adapt(model: entity)
        }
        
        guard let category = state.category ?? categories.first,
              let budget = budgetRepository.getBudget(on: category.id, from: date) else {
            return completion(.updateCategories(categories, .init(), .zero, ""))
        }
        
        completion(.updateCategories(categories, budget.id, budget.amount, budget.message ?? ""))
    }
    
    private func fetchBudget(
        from date: Date,
        by id: UUID,
        on completion: @escaping (AddBudgetAction) -> Void
    ) {
        guard let budget = budgetRepository.getBudget(on: id, from: date) else {
            let predictValue = intelligence.predict(for: .budgetFromTransactions(date: date, category: id), with: .budgetFromTransactions, on: .high) ?? .zero
            return completion(.updateBudget(.init(), predictValue, "", predictValue != .zero))
        }
        
        completion(.updateBudget(budget.id, budget.amount, budget.message ?? "", false))
    }
    
    private func save(
        _ budget: AddBudgetStateProtocol,
        on completion: @escaping (AddBudgetAction) -> Void
    ) {
        guard let category = budget.category else {
            return completion(.updateError(.notFoundCategory))
        }
        
        do {
            try budgetRepository.addBudget(
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
        WidgetCenter.shared.reloadAllTimelines()
        completion(.dismiss)
    }
}
