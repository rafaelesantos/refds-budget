import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class CategoryMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
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
            let categories = categoryRepository.getAllCategories().map { entity in
                adapter.adaptCategory(entity: entity)
            }
            completion(.updateCategories(categories))
            
        case let .fetchBudget(date, id):
            guard let budget = categoryRepository.getBudget(on: id, from: date) else {
                return completion(.updateBudget(.init(), .zero, ""))
            }
            completion(.updateBudget(budget.id, budget.amount, budget.message ?? ""))
            
        case let .save(budget):
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
            } catch {
                return completion(.updateError(.existingBudget))
            }
            
            guard let category = categoryRepository.getCategory(by: category.id) else {
                return completion(.updateError(.notFoundCategory))
            }
            
            do {
                try categoryRepository.addCategory(
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
        case let .fetchCategory(category):
            var category = category
            guard let entity = categoryRepository.getCategory(by: category.id) else {
                category.showSaveButton = true
                return completion(.updateCategroy(category))
            }
            let adapted = adapter.adaptCategory(entity: entity)
            category = adapted
            category.showSaveButton = false
            completion(.updateCategroy(category))
            
        case let .save(category):
            let budgets = categoryRepository.getBudgets(on: category.id)
            do {
                try categoryRepository.addCategory(
                    id: category.id,
                    name: category.name,
                    color: category.color,
                    budgets: budgets.map { $0.id },
                    icon: category.icon
                )
            } catch {
                return completion(.updateError(.existingCategory))
            }
            
            if category.showSaveButton { completion(.dismiss) }
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
                let categories = categoryRepository.getAllCategories().map {
                    let budgets = categoryRepository.getBudgets(on: $0.id)
                    let budgetsAmount = budgets.map { $0.amount }.reduce(.zero, +)
                    let transactions = transactionRepository.getTransactions(on: $0.id)
                    let spend = transactions.map { $0.amount }.reduce(.zero, +)
                    let percentage = spend / (budgetsAmount == .zero ? 1 : budgetsAmount)
                    return CategoryRowViewData(
                        icon: $0.icon,
                        name: $0.name,
                        description: nil,
                        color: Color(hex: $0.color),
                        budget: budgetsAmount,
                        percentage: percentage,
                        transactionsAmount: transactions.count,
                        spend: spend
                    )
                }
                
                return completion(.updateCategories(categories))
            }
            
            let categories = categoryRepository.getCategories(from: date).map {
                let budget = categoryRepository.getBudget(on: $0.id, from: date)
                let transactions = transactionRepository.getTransactions(on: $0.id, from: date, format: .monthYear)
                let spend = transactions.map { $0.amount }.reduce(.zero, +)
                let percentage = spend / ((budget?.amount ?? 1) == .zero ? 1 : (budget?.amount ?? 1))
                return CategoryRowViewData(
                    icon: $0.icon,
                    name: $0.name,
                    description: budget?.message,
                    color: Color(hex: $0.color),
                    budget: budget?.amount ?? .zero,
                    percentage: percentage,
                    transactionsAmount: transactions.count,
                    spend: spend
                )
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
            let categories = categoryRepository.getCategories(from: date).map {
                adapter.adaptCategory(entity: $0)
            }
            completion(.updateCategories(categories))
        default:
            break
        }
    }
}
