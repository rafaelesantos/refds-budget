import Foundation
import SwiftUI
import WidgetKit
import RefdsRedux
import RefdsShared
import RefdsInjection
import Domain
import Resource

public final class CategoryMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var tagRepository: TagUseCase
    @RefdsInjection private var budgetRepository: BudgetUseCase
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    @RefdsInjection private var categoryAdapter: CategoryAdapterProtocol
    @RefdsInjection private var budgetRowViewDataAdapter: BudgetItemViewDataAdapterProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        switch action {
        case let action as CategoryAction: self.handler(with: state.categoryState, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: CategoryStateProtocol,
        for action: CategoryAction,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        switch action {
        case .fetchData:
            fetchData(
                for: state.id,
                with: state.filter,
                on: completion
            )
        case let .removeBudget(id):
            remove(
                budget: id,
                on: completion
            )
        case let .removeCategory(id):
            remove(
                category: id,
                on: completion
            )
        default: break
        }
    }
    
    private func fetchData(
        for id: UUID?,
        with filter: FilterViewDataProtocol,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        guard let id = id, let model = categoryRepository.getCategory(by: id) else { return }
        
        let budgets = budgetRepository.getBudgets(on: id).map { budget in
            let spend: Double = transactionRepository.getTransactions(
                on: id,
                from: budget.date.date,
                format: .monthYear
            ).compactMap { transaction in
                guard let status = TransactionStatus(rawValue: transaction.status),
                      status != .pending,
                      status != .cleared
                else { return nil }
                return transaction.amount
            }.reduce(.zero, +)
            let percentage = spend / (budget.amount == .zero ? 1 : budget.amount)
            return budgetRowViewDataAdapter.adapt(
                model: budget,
                spend: spend,
                percentage: percentage
            )
        }
        
        let budget = budgets.map { $0.amount }.reduce(.zero, +)
        let spend = budgets.map { $0.spend }.reduce(.zero, +)
        let percentage = spend / (budget == .zero ? 1 : budget)
        
        let category = categoryAdapter.adapt(
            model: model,
            budgetDescription: nil,
            budget: budget,
            percentage: percentage,
            transactionsAmount: .zero,
            spend: spend
        )
        
        let description = budgets.first?.description
        
        if let range: ClosedRange<Int> = .range(
            page: filter.currentPage,
            amount: filter.amountPage,
            count: budgets.count
        ) {
            let total = budgets.count
            let budgets = Array(budgets[range])
            let canChangePage = total - (filter.currentPage * budgets.count) > 0
            completion(
                .updateData(
                    description: description,
                    category: category,
                    budgets: budgets,
                    canChangePage: canChangePage
                )
            )
        } else {
            completion(
                .updateData(
                    description: description,
                    category: category,
                    budgets: budgets,
                    canChangePage: false
                )
            )
        }
    }
    
    private func remove(
        budget id: UUID,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        guard let _ = budgetRepository.getBudget(by: id) else {
            return completion(.updateError(.notFoundBudget))
        }
        
        do {
            try budgetRepository.removeBudget(id: id)
            WidgetCenter.shared.reloadAllTimelines()
            completion(.fetchData)
        } catch { 
            completion(.updateError(.cantDeleteBudget))
        }
    }
    
    private func remove(
        category id: UUID,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        guard let _ = categoryRepository.getCategory(by: id) else {
            return completion(.updateError(.notFoundCategory))
        }
        
        let transactions = transactionRepository.getTransactions(on: id)
        
        guard transactions.isEmpty else {
            return completion(.updateError(.cantDeleteCategory))
        }
        
        do {
            try categoryRepository.removeCategory(id: id)
        } catch { completion(.updateError(.cantDeleteCategory)) }
        
        WidgetCenter.shared.reloadAllTimelines()
        let router = RefdsContainer.resolve(type: ApplicationRouterActionProtocol.self)
        router.to(scene: .current, view: .dismiss, viewStates: [])
    }
}
