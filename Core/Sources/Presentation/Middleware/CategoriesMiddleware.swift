import Foundation
import SwiftUI
import WidgetKit
import RefdsRedux
import RefdsShared
import RefdsInjection
import Domain
import Resource

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
        let date = state.filter.isDateFilter ? state.filter.date : nil
        switch categoriesAction {
        case .fetchData:
            fetchData(
                from: date,
                selectedItems: state.filter.selectedItems,
                on: completion
            )
        case let .removeCategory(id):
            removeCategory(
                with: state,
                from: date,
                by: id,
                on: completion
            )
        default: break
        }
    }
    
    private func fetchData(
        from date: Date?,
        selectedItems: Set<String>,
        on completion: @escaping (CategoriesAction) -> Void
    ) {
        let allEntities = categoryRepository.getAllCategories()
        var categoriesEntity: [CategoryModelProtocol] = []
        
        if let date = date {
            categoriesEntity = categoryRepository.getCategories(from: date)
        } else {
            categoriesEntity = allEntities
        }
        
        let categories: [CategoryItemViewDataProtocol] = categoriesEntity.compactMap {
            var budgetsEntity: [BudgetModelProtocol] = []
            
            if let date = date, let budget = budgetRepository.getBudget(on: $0.id, from: date) {
                budgetsEntity += [budget]
            } else if date == nil {
                budgetsEntity = budgetRepository.getBudgets(on: $0.id)
            }
            
            let budget = budgetsEntity.last
            let budgetAmount = budgetsEntity.map { $0.amount }.reduce(.zero, +)
            
            return categoryAdapter.adapt(
                model: $0,
                budgetDescription: date == nil ? nil : budget?.message,
                budget: budgetAmount,
                percentage: .zero,
                transactionsAmount: .zero,
                spend: .zero
            )
        }
        
        completion(
            .updateCategories(
                categories.sorted(by: { $0.name < $1.name }),
                [],
                allEntities.isEmpty
            )
        )
        
        let categoriesName = categories.map { $0.name }
        let categoriesWithoutBudget = date == nil ? [] : allEntities.compactMap {
            categoryAdapter.adapt(
                model: $0,
                budgetDescription: nil,
                budget: .zero,
                percentage: .zero,
                transactionsAmount: .zero,
                spend: .zero
            )
        }.filter {
            categoriesName.isEmpty ? true : !categoriesName.contains($0.name)
        }
        
        completion(
            .updateCategories(
                categories.sorted(by: { $0.name < $1.name }),
                categoriesWithoutBudget,
                allEntities.isEmpty
            )
        )
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
