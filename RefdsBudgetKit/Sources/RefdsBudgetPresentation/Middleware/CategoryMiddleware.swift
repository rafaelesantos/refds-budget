import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class CategoryMiddleware: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var repository: CategoryUseCase
    @RefdsInjection private var adapter: CategoryAdapterProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<any RefdsReduxState> = { _, action, completion in
        switch action {
        case is AddBudgetAction:
            self.handler(for: action as? AddBudgetAction, on: completion)
        case is AddCategoryAction:
            self.handler(for: action as? AddCategoryAction, on: completion)
        case is CategoriesAction:
            self.handler(for: action as? CategoriesAction, on: completion)
        case is AddTransactionAction:
            self.handler(for: action as? AddTransactionAction, on: completion)
        default:
            break
        }
    }
    
    private func handler(
        for addBudgetAction: AddBudgetAction?,
        on completion: RefdsReduxMiddlewareCompletion
    ) {
        switch addBudgetAction {
        case let .save(budget):
            do {
                try repository.addBudget(
                    id: budget.id,
                    amount: budget.amount,
                    date: budget.month,
                    message: budget.description,
                    category: budget.categoryId
                )
            } catch {
                return completion(AddBudgetAction.updateError(.existingBudget))
            }
            
            guard let category = repository.getCategory(by: budget.categoryId) else {
                return completion(AddBudgetAction.updateError(.notFoundCategory))
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
                return completion(AddBudgetAction.updateError(.existingCategory))
            }
            
            completion(AddBudgetAction.dismiss)
        default:
            break
        }
    }
    
    private func handler(
        for addCategoryAction: AddCategoryAction?,
        on completion: RefdsReduxMiddlewareCompletion
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
                return completion(AddCategoryAction.updateError(.existingCategory))
            }
            
            completion(AddCategoryAction.dismiss)
        default:
            break
        }
    }
    
    private func handler(
        for categoriesAction: CategoriesAction?,
        on completion: RefdsReduxMiddlewareCompletion
    ) {
        switch categoriesAction {
        case let .fetchCategories(date):
            guard let date = date else {
                let categories = repository.getAllCategories().map {
                    let budgets = repository.getBudgets(by: $0.budgets)
                    return adapter.adapt(category: $0, budgets: budgets)
                }
                
                return completion(CategoriesAction.updateCategories(categories))
            }
            
            let categories = repository.getCategories(from: date).map {
                let budgets = repository.getBudgets(by: $0.budgets)
                return adapter.adapt(category: $0, budgets: budgets)
            }
            
            completion(CategoriesAction.updateCategories(categories))
        default:
            break
        }
    }
    
    private func handler(
        for addBudgetAction: AddTransactionAction?,
        on completion: RefdsReduxMiddlewareCompletion
    ) {
        switch addBudgetAction {
        case let .fetchCategories(date):
            let categories = repository.getCategories(from: date).map {
                let budgets = repository.getBudgets(by: $0.budgets)
                return adapter.adapt(category: $0, budgets: budgets)
            }
            completion(AddTransactionAction.updateCategories(categories))
        default:
            break
        }
    }
}
