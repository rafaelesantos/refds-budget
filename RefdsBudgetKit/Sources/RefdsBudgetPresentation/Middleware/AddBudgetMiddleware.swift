import Foundation
import SwiftUI
import WidgetKit
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class AddBudgetMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @Environment(\.navigate) private var navigate
    @RefdsInjection private var budgetRepository: BudgetUseCase
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var categoryAdapter: CategoryAdapterProtocol
    @RefdsInjection private var intelligence: IntelligenceProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        
        switch action {
        case let action as AddBudgetAction: 
            self.handler(
                with: state.addBudgetState,
                for: action,
                on: completion
            )
        default: 
            break
        }
    }
    
    private func handler(
        with state: AddBudgetStateProtocol,
        for action: AddBudgetAction,
        on completion: @escaping (AddBudgetAction) -> Void
    ) {
        switch action {
        case .fetchData:
            fetchData(
                with: state,
                on: completion
            )
        case .fetchBudget:
            fetchBudget(
                with: state,
                on: completion
            )
        case .save:
            save(
                with: state,
                on: completion
            )
        default:
            break
       }
    }
    
    private func fetchData(
        with state: AddBudgetStateProtocol,
        on completion: @escaping (AddBudgetAction) -> Void
    ) {
        let date = budgetRepository.getBudget(by: state.id)?.date.date ?? state.date
        
        let categories: [CategoryRowViewDataProtocol] = categoryRepository.getAllCategories().map {
            let budget = budgetRepository.getBudget(on: $0.id, from: date)?.amount ?? .zero
            return ($0, budget)
        }.sorted(by: { 
            $0.1 < $1.1
        }).map {
            $0.0
        }.map { model in
            categoryAdapter.adapt(
                model: model,
                budgetDescription: nil,
                budget: .zero,
                percentage: .zero,
                transactionsAmount: .zero,
                spend: .zero
            )
        }
        
        guard let budget = budgetRepository.getBudget(by: state.id) else {
            let category = categories.first(where: { 
                $0.name.lowercased() == state.categoryName?.lowercased()
            }) ?? categories.first
            return completion(
                .updateData(
                    id: state.id,
                    description: state.description,
                    date: date,
                    amount: state.amount,
                    category: category,
                    categories: categories
                )
            )
        }

        completion(
            .updateData(
                id: budget.id,
                description: budget.message ?? "",
                date: budget.date.date,
                amount: budget.amount,
                category: categories.first(where: { $0.id == budget.category }),
                categories: categories
            )
        )
    }
    
    private func fetchBudget(
        with state: AddBudgetStateProtocol,
        on completion: @escaping (AddBudgetAction) -> Void
    ) {
        guard let category = state.category else { return }
        guard let budget = budgetRepository.getBudget(on: category.id, from: state.date) else {
            var amount: Double = .zero
            if state.hasAISuggestion {
                amount = intelligence.predict(
                    for: .budgetFromTransactions(date: state.date, category: category.id),
                    with: .budgetFromTransactions(nil),
                    on: .ultra
                ) ?? amount
            }
            return completion(
                .updateBudget(
                    id: state.id,
                    description: "",
                    amount: amount
                )
            )
        }
        
        var amount = budget.amount
        if state.hasAISuggestion {
            amount = intelligence.predict(
                for: .budgetFromTransactions(date: state.date, category: category.id),
                with: .budgetFromTransactions(nil),
                on: .ultra
            ) ?? amount
        }
        return completion(
            .updateBudget(
                id: budget.id,
                description: budget.message ?? "",
                amount: amount
            )
        )
    }
    
    private func save(
        with state: AddBudgetStateProtocol,
        on completion: @escaping (AddBudgetAction) -> Void
    ) {
        guard let category = state.category else {
            return completion(.updateError(.notFoundCategory))
        }
        
        do {
            try budgetRepository.addBudget(
                id: state.id,
                amount: state.amount,
                date: state.date,
                message: state.description,
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
                budgets: category.budgets + [state.id],
                icon: category.icon
            )
        } catch { return completion(.updateError(.existingCategory)) }
        
        WidgetCenter.shared.reloadAllTimelines()
        navigate?.to(
            scene: .current,
            view: .dismiss,
            viewStates: []
        )
    }
}
