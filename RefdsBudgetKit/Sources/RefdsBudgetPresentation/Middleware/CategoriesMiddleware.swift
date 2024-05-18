import Foundation
import SwiftUI
import WidgetKit
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class CategoriesMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var tagRepository: BubbleUseCase
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    @RefdsInjection private var categoryAdapter: CategoryAdapterProtocol
    @RefdsInjection private var budgetAdapter: BudgetAdapterProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        switch action {
        case let action as CategoriesAction: self.handler(with: state.categoriesState, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: CategoriesStateProtocol,
        for categoriesAction: CategoriesAction,
        on completion: @escaping (CategoriesAction) -> Void
    ) {
        switch categoriesAction {
        case .fetchData: 
            let date = state.isFilterEnable ? state.date : nil
            fetchData(
                from: date,
                tagsName: state.selectedTags,
                status: state.selectedStatus,
                on: completion
            )
        case let .fetchBudgetForEdit(date, categoryId, budgetId): fetchBudgetForEdit(from: date, categoryId: categoryId, budgetId: budgetId, on: completion)
        case let .fetchCategoryForEdit(categoryId): fetchCategoryForEdit(with: categoryId, on: completion)
        case let .removeBudget(date, id): removeBudget(with: state, from: date, by: id, on: completion)
        case let .removeCategory(date, id): removeCategory(with: state, from: date, by: id, on: completion)
        default: break
        }
    }
    
    private func fetchData(
        from date: Date?,
        tagsName: Set<String>,
        status: Set<String>,
        on completion: @escaping (CategoriesAction) -> Void
    ) {
        let allEntities = categoryRepository.getAllCategories()
        var categoriesEntity: [CategoryEntity] = []
        let tags = tagRepository.getBubbles().map { $0.name }
        
        if let date = date {
            categoriesEntity = categoryRepository.getCategories(from: date)
        } else {
            categoriesEntity = allEntities
        }
        
        let categories: [CategoryRowViewDataProtocol] = categoriesEntity.compactMap {
            var budgetsEntity: [BudgetEntity] = []
            var transactionsEntity: [TransactionEntity] = []
            
            if let date = date, let budget = categoryRepository.getBudget(on: $0.id, from: date) {
                budgetsEntity += [budget]
                transactionsEntity = transactionRepository.getTransactions(on: $0.id, from: date, format: .monthYear).filter {
                    if status.isEmpty {
                        return $0.status != TransactionStatus.pending.rawValue &&
                        $0.status != TransactionStatus.cleared.rawValue
                    } else {
                        return true
                    }
                }
            } else if date == nil {
                budgetsEntity = categoryRepository.getBudgets(on: $0.id)
                transactionsEntity = transactionRepository.getTransactions(on: $0.id).filter {
                    if status.isEmpty {
                        return $0.status != TransactionStatus.pending.rawValue &&
                        $0.status != TransactionStatus.cleared.rawValue
                    } else {
                        return true
                    }
                }
            }
            
            if !tagsName.isEmpty {
                transactionsEntity = transactionsEntity.filter { transaction in
                    for tagName in tagsName {
                        if transaction.message
                            .folding(options: .diacriticInsensitive, locale: .current)
                            .lowercased()
                            .contains(
                                tagName
                                    .folding(options: .diacriticInsensitive, locale: .current)
                                    .lowercased()
                            ) {
                            return true
                        }
                    }
                    return false
                }
            }
            
            if !status.isEmpty {
                transactionsEntity = transactionsEntity.filter {
                    status.contains(TransactionStatus(rawValue: $0.status)?.description ?? "")
                }
            }
            
            guard let budget = budgetsEntity.last else { return nil }
            let budgetAmount = budgetsEntity.map { $0.amount }.reduce(.zero, +)
            let spend = transactionsEntity.map { $0.amount }.reduce(.zero, +)
            let percentage = spend / (budgetAmount == .zero ? 1 : budgetAmount)
            
            return categoryAdapter.adapt(
                entity: $0,
                budgetId: budget.id,
                budgetDescription: budget.message,
                budget: budgetAmount,
                percentage: percentage,
                transactionsAmount: transactionsEntity.count,
                spend: spend
            )
        }
        
        completion(.updateCategories(categories.sorted(by: { $0.name < $1.name }), allEntities.isEmpty, tags))
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
        with state: CategoriesStateProtocol,
        from date: Date,
        by id: UUID,
        on completion: @escaping (CategoriesAction) -> Void
    ) {
        guard let budgetEntity = categoryRepository.getBudget(by: id) else {
            return completion(.updateError(.notFoundBudget))
        }
        
        do {
            try categoryRepository.removeBudget(id: budgetEntity.id)
            WidgetCenter.shared.reloadAllTimelines()
            completion(.fetchData)
        } catch {
            completion(.updateError(.cantDeleteBudget))
        }
    }
    
    private func removeCategory(
        with state: CategoriesStateProtocol,
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
        
        WidgetCenter.shared.reloadAllTimelines()
        completion(.fetchData)
    }
}
