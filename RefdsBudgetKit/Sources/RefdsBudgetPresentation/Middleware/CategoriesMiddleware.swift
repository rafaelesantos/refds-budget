import Foundation
import SwiftUI
import WidgetKit
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class CategoriesMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var tagRepository: TagUseCase
    @RefdsInjection private var budgetRepository: BudgetUseCase
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
        case let .fetchCategoryForEdit(categoryId): fetchCategoryForEdit(with: categoryId, on: completion)
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
        var categoriesEntity: [CategoryModelProtocol] = []
        let tags = tagRepository.getTags().map { $0.name }
        
        if let date = date {
            categoriesEntity = categoryRepository.getCategories(from: date)
        } else {
            categoriesEntity = allEntities
        }
        
        let categories: [CategoryRowViewDataProtocol] = categoriesEntity.compactMap {
            var budgetsEntity: [BudgetModelProtocol] = []
            var transactionsEntity: [TransactionModelProtocol] = []
            
            if let date = date, let budget = budgetRepository.getBudget(on: $0.id, from: date) {
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
                budgetsEntity = budgetRepository.getBudgets(on: $0.id)
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
                    var contains = true
                    for tagName in tagsName {
                        if !transaction.message
                            .folding(options: .diacriticInsensitive, locale: .current)
                            .lowercased()
                            .contains(
                                tagName
                                    .folding(options: .diacriticInsensitive, locale: .current)
                                    .lowercased()
                            ) {
                            contains = false
                        }
                    }
                    return contains
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
                model: $0,
                budgetId: budget.id,
                budgetDescription: budget.message,
                budget: budgetAmount,
                percentage: percentage,
                transactionsAmount: transactionsEntity.count,
                spend: spend
            )
        }
        completion(
            .updateCategories(
                categories.sorted(by: { $0.name < $1.name }),
                allEntities.isEmpty,
                tags
            )
        )
    }
    
    private func fetchCategoryForEdit(
        with id: UUID,
        on completion: @escaping (CategoriesAction) -> Void
    ) {
        if let category = categoryRepository.getCategory(by: id) {
            completion(.addCategory(categoryAdapter.adapt(model: category)))
        } else { completion(.updateError(.notFoundCategory)) }
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
