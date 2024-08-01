import Foundation
import SwiftUI
import WidgetKit
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class BudgetSelectionMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var budgetRepository: BudgetUseCase
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    @RefdsInjection private var budgetAdapter: BudgetRowViewDataAdapterProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        switch action {
        case let action as BudgetSelectionAction: self.handler(with: state.budgetSelectionState, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: BudgetSelectionStateProtocol,
        for action: BudgetSelectionAction,
        on completion: @escaping (BudgetSelectionAction) -> Void
    ) {
        switch action {
        case .fetchData: fetchData(on: completion)
        default: break
        }
    }
    
    private func fetchData(on completion: @escaping (BudgetSelectionAction) -> Void) {
        let budgetModels = budgetRepository.getAllBudgets()
        let categoryModels = categoryRepository.getAllCategories()
        let transactionModels = transactionRepository.getAllTransactions().filter {
            TransactionStatus(rawValue: $0.status) != .cleared
        }
        
        let categoriesGroup = Dictionary(
            grouping: categoryModels,
            by: { $0.id.uuidString }
        )
        
        let transactionsGroup = Dictionary(
            grouping: transactionModels,
            by: { $0.date.asString(withDateFormat: .monthYear) }
        )
        
        let budgetsGroup = Dictionary(
            grouping: budgetModels,
            by: { $0.date.asString(withDateFormat: .year) }
        ).sorted(by: { $0.key > $1.key }).map { item in
            let groupByMonth = Dictionary(
                grouping: item.value,
                by: { $0.date.asString(withDateFormat: .month) }
            ).compactMap { item in
                adaptedJoinBudget(
                    budgets: item.value,
                    transactions: transactionsGroup,
                    for: categoriesGroup
                )
            }
            
            return groupByMonth.sorted(by: {
                $0.date.asString(withDateFormat: .custom("MM")) >
                $1.date.asString(withDateFormat: .custom("MM"))
            })
        }
        completion(.updateCategories(budgetsGroup))
    }
    
    private func adaptedJoinBudget(
        budgets: [BudgetModelProtocol],
        transactions: [String: [TransactionModelProtocol]],
        for categoriesGroup: [String: [CategoryModelProtocol]]
    ) -> BudgetRowViewDataProtocol? {
        let description = budgets.compactMap {
            categoriesGroup[$0.category.uuidString]?.first?.name
        }.joined(separator: ", ").capitalizedSentence
        let amount = budgets.map { $0.amount }.reduce(.zero, +)
        if let budget = budgets.first {
            let spend = transactions[budget.date.asString(withDateFormat: .monthYear)]?.map { $0.amount }.reduce(.zero, +) ?? .zero
            let percentage = spend / (amount == .zero ? 1 : amount)
            return BudgetRowViewData(
                id: budget.id,
                date: budget.date.date,
                description: description.isEmpty ? nil : description,
                amount: amount,
                spend:  spend,
                percentage: percentage
            )
        }
        
        return nil
    }
}
