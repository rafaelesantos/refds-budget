import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class CategoriesMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    @RefdsInjection private var categoryAdapter: CategoryAdapterProtocol
    @RefdsInjection private var budgetAdapter: BudgetAdapterProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { _, action, completion in
        switch action {
        case let action as CategoriesAction: self.handler(for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        for categoriesAction: CategoriesAction,
        on completion: @escaping (CategoriesAction) -> Void
    ) {
        switch categoriesAction {
        case let .fetchData(date): fetchData(from: date, on: completion)
        case let .fetchBudgetForEdit(date, categoryId, budgetId): fetchBudgetForEdit(from: date, categoryId: categoryId, budgetId: budgetId, on: completion)
        case let .fetchCategoryForEdit(categoryId): fetchCategoryForEdit(with: categoryId, on: completion)
        case let .removeBudget(date, id): removeBudget(from: date, by: id, on: completion)
        case let .removeCategory(date, id): removeCategory(from: date, by: id, on: completion)
        default: break
        }
    }
    
    private func fetchData(
        from date: Date?,
        on completion: @escaping (CategoriesAction) -> Void
    ) {
        let allEntities = categoryRepository.getAllCategories()
        guard let date = date else {
            let categories = allEntities.map {
                let budgets = categoryRepository.getBudgets(on: $0.id)
                let budget = budgets.map { $0.amount }.reduce(.zero, +)
                let transactions = transactionRepository.getTransactions(on: $0.id)
                let spend = transactions.map { $0.amount }.reduce(.zero, +)
                let percentage = spend / (budget == .zero ? 1 : budget)
                return categoryAdapter.adapt(
                    entity: $0,
                    budgetId: budgets.first?.id ?? .init(),
                    budgetDescription: nil,
                    budget: budget,
                    percentage: percentage,
                    transactionsAmount: transactions.count,
                    spend: spend
                )
            }
            
            return completion(.updateCategories(categories, allEntities.isEmpty))
        }
        
        let entities = categoryRepository.getCategories(from: date)
        let categories = entities.map {
            let budget = categoryRepository.getBudget(on: $0.id, from: date)
            let transactions = transactionRepository.getTransactions(on: $0.id, from: date, format: .monthYear)
            let spend = transactions.map { $0.amount }.reduce(.zero, +)
            let percentage = spend / ((budget?.amount ?? 1) == .zero ? 1 : (budget?.amount ?? 1))
            return categoryAdapter.adapt(
                entity: $0,
                budgetId: budget?.id ?? .init(),
                budgetDescription: budget?.message,
                budget: budget?.amount ?? .zero,
                percentage: percentage,
                transactionsAmount: transactions.count,
                spend: spend
            )
        }
        
        completion(.updateCategories(categories, allEntities.isEmpty))
    }
    
    private func fetchBudgetForEdit(
        from date: Date,
        categoryId: UUID,
        budgetId: UUID,
        on completion: @escaping (CategoriesAction) -> Void
    ) {
        let categories = categoryRepository.getAllCategories().map {
            categoryAdapter.adapt(entity: $0)
        }
        
        if let categoryEntity = categoryRepository.getCategory(by: categoryId) {
            let entity = categoryRepository.getBudget(by: budgetId)
            let state = budgetAdapter.adapt(
                entity: entity,
                category: categoryAdapter.adapt(entity: categoryEntity),
                categories: categories
            )
            
            completion(.addBudget(state, date))
        } else { completion(.updateError(.notFoundCategory)) }
    }
    
    private func fetchCategoryForEdit(
        with id: UUID,
        on completion: @escaping (CategoriesAction) -> Void
    ) {
        if let category = categoryRepository.getCategory(by: id) {
            completion(.addCategory(categoryAdapter.adapt(entity: category)))
        } else { completion(.updateError(.notFoundCategory)) }
    }
    
    private func removeBudget(
        from date: Date,
        by id: UUID,
        on completion: @escaping (CategoriesAction) -> Void
    ) {
        guard let budgetEntity = categoryRepository.getBudget(by: id) else {
            return completion(.updateError(.notFoundBudget))
        }
        
        guard let category = categoryRepository.getCategory(by: budgetEntity.category) else {
            return completion(.updateError(.notFoundCategory))
        }
        
        let transactions = transactionRepository.getTransactions(
            on: category.id,
            from: budgetEntity.date.date,
            format: .monthYear
        )
        
        guard transactions.isEmpty else {
            return completion(.updateError(.cantDeleteBudget))
        }
        
        do {
            try categoryRepository.removeBudget(id: budgetEntity.id)
        } catch { completion(.updateError(.cantDeleteBudget)) }
        
        guard category.budgets.count > 1 else {
            do {
                try categoryRepository.removeCategory(id: category.id)
            } catch { completion(.updateError(.cantDeleteCategory)) }
            return
        }
        
        fetchData(from: date, on: completion)
    }
    
    private func removeCategory(
        from date: Date?,
        by id: UUID,
        on completion: @escaping (CategoriesAction) -> Void
    ) {
        guard let categoryEntity = categoryRepository.getCategory(by: id) else {
            return completion(.updateError(.notFoundCategory))
        }
        
        let transactions = transactionRepository.getTransactions(on: categoryEntity.id)
        
        guard transactions.isEmpty else {
            return completion(.updateError(.cantDeleteCategory))
        }
        
        do {
            try categoryRepository.removeCategory(id: categoryEntity.id)
        } catch { completion(.updateError(.cantDeleteCategory)) }
        
        fetchData(from: date, on: completion)
    }
}
