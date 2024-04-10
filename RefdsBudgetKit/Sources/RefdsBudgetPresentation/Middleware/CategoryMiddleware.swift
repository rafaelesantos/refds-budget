import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class CategoryMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var repository: CategoryUseCase
    @RefdsInjection private var adapter: CategoryAdapterProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { _, action, completion in
        switch action {
        case let action as AddBudgetAction:
            self.handler(for: action, on: completion)
        case let action as AddCategoryAction:
            self.handler(for: action, on: completion)
        case let action as CategoriesAction:
            self.handler(for: action, on: completion)
        case let action as AddTransactionAction:
            self.handler(for: action, on: completion)
        default:
            break
        }
    }
    
    private func handler(
        for addBudgetAction: AddBudgetAction,
        on completion: (AddBudgetAction) -> Void
    ) {
        switch addBudgetAction {
        case .fetchCategories:
            let categories = repository.getAllCategories().map { entity in
                let budgets = repository.getBudgets(by: entity.budgets)
                return adapter.adapt(category: entity, budgets: budgets)
            }
            completion(.updateCategories(categories))
            
        case let .fetchBudget(date, id):
            guard let budget = repository.getBudget(on: id, from: date) else {
                return completion(.updateBudget(.init(), .zero, ""))
            }
            completion(.updateBudget(budget.id, budget.amount, budget.message ?? ""))
            
        case let .save(budget):
            guard let category = budget.category else {
                return completion(.updateError(.notFoundCategory))
            }
            
            do {
                try repository.addBudget(
                    id: budget.id,
                    amount: budget.amount,
                    date: budget.month,
                    message: budget.description,
                    category: category.id
                )
            } catch {
                return completion(.updateError(.existingBudget))
            }
            
            guard let category = repository.getCategory(by: category.id) else {
                return completion(.updateError(.notFoundCategory))
            }
            
            do {
                try repository.addCategory(
                    id: category.id,
                    name: category.name,
                    color: Color(hex: category.color),
                    budgets: category.budgets + [budget.id],
                    icon: category.icon
                )
            } catch {
                return completion(.updateError(.existingCategory))
            }
            
            completion(.dismiss)
        default:
            break
        }
    }
    
    private func handler(
        for addCategoryAction: AddCategoryAction,
        on completion: (AddCategoryAction) -> Void
    ) {
        switch addCategoryAction {
        case let .save(category):
            do {
                try repository.addCategory(
                    id: category.id,
                    name: category.name,
                    color: category.color,
                    budgets: category.budgets.map { $0.id },
                    icon: category.icon
                )
            } catch {
                return completion(.updateError(.existingCategory))
            }
            
            completion(.dismiss)
        default:
            break
        }
    }
    
    private func handler(
        for categoriesAction: CategoriesAction,
        on completion: (CategoriesAction) -> Void
    ) {
        switch categoriesAction {
        case let .fetchCategories(date):
            guard let date = date else {
                let categories = repository.getAllCategories().map {
                    let budgets = repository.getBudgets(by: $0.budgets)
                    return adapter.adapt(category: $0, budgets: budgets)
                }
                
                return completion(.updateCategories(categories))
            }
            
            let categories = repository.getCategories(from: date).map {
                let budgets = repository.getBudgets(by: $0.budgets)
                return adapter.adapt(category: $0, budgets: budgets)
            }
            
            completion(.updateCategories(categories))
        default:
            break
        }
    }
    
    private func handler(
        for addBudgetAction: AddTransactionAction,
        on completion: (AddTransactionAction) -> Void
    ) {
        switch addBudgetAction {
        case let .fetchCategories(date):
            let categories = repository.getCategories(from: date).map {
                let budgets = repository.getBudgets(by: $0.budgets)
                return adapter.adapt(category: $0, budgets: budgets)
            }
            completion(.updateCategories(categories))
        default:
            break
        }
    }
}
