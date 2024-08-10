import Foundation
import SwiftUI
import WidgetKit
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class BudgetComparisonMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var tagRepository: TagUseCase
    @RefdsInjection private var budgetRepository: BudgetUseCase
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionsRepository: TransactionUseCase
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        switch action {
        case let action as BudgetComparisonAction: self.handler(
            with: state,
            for: action,
            on: completion
        )
        default: break
        }
    }
    
    private func handler(
        with state: ApplicationStateProtocol,
        for action: BudgetComparisonAction,
        on completion: @escaping (BudgetComparisonAction) -> Void
    ) {
        switch action {
        case .fetchData: fetchData(with: state, on: completion)
        default: break
        }
    }
    
    private func fetchData(
        with state: ApplicationStateProtocol,
        on completion: @escaping (BudgetComparisonAction) -> Void
    ) {
        let budgetsSelected = Array(state.budgetSelectionState.budgetsSelected)
        let budgets = state.budgetSelectionState.budgets.flatMap { $0 }
        guard let baseBudgetId = budgetsSelected[safe: 0],
              let compareBudgetId = budgetsSelected[safe: 1],
              baseBudgetId != compareBudgetId,
              let baseBudget = budgets.first(where: { $0.id == baseBudgetId }),
              let compareBudget = budgets.first(where: { $0.id == compareBudgetId })
        else { return }
        
        let baseBudgetSorted = baseBudget.date < compareBudget.date ? baseBudget : compareBudget
        let compareBudgetSorted = baseBudget.date < compareBudget.date ? compareBudget : baseBudget
        
        completion(
            .updateData(
                baseBudgetSorted,
                compareBudgetSorted,
                [],
                []
            )
        )
        
        let tagModels = tagRepository.getTags()
        let budgetModels = budgetRepository.getAllBudgets()
        let categoryModels = categoryRepository.getAllCategories()
        let transactionModels = transactionsRepository.getAllTransactions()
        
        let categoriesChart = getCategoriesChart(
            baseBudget: baseBudgetSorted,
            compareBudget: compareBudgetSorted,
            budgets: budgetModels,
            categories: categoryModels,
            transactions: transactionModels
        )
        
        completion(
            .updateData(
                baseBudgetSorted,
                compareBudgetSorted,
                categoriesChart,
                []
            )
        )
        
        let tagsChart = getTagsChart(
            baseBudget: baseBudgetSorted,
            compareBudget: compareBudgetSorted,
            budgets: budgetModels,
            tags: tagModels,
            transactions: transactionModels
        )
        
        completion(
            .updateData(
                baseBudgetSorted,
                compareBudgetSorted,
                categoriesChart,
                tagsChart
            )
        )
    }
    
    private func getCategoriesChart(
        baseBudget: BudgetRowViewDataProtocol,
        compareBudget: BudgetRowViewDataProtocol,
        budgets: [BudgetModelProtocol],
        categories: [CategoryModelProtocol],
        transactions: [TransactionModelProtocol]
    ) -> [BudgetComparisonChartViewDataProtocol] {
        let baseCategories = categoryRepository.getCategories(from: baseBudget.date)
        let compareCategories = categoryRepository.getCategories(from: compareBudget.date)
        
        return categories.compactMap { category in
            var viewData = BudgetComparisonChartViewData(
                icon: RefdsIconSymbol(rawValue: category.icon),
                color: Color(hex: category.color),
                domain: category.name.capitalized,
                base: .zero,
                compare: .zero,
                budgetBase: .zero,
                budgetCompare: .zero
            )
            
            if baseCategories.contains(where: { $0.id == category.id }),
               let budget = budgets.first(where: {
                   $0.category == category.id &&
                   $0.date.asString(withDateFormat: .monthYear) == baseBudget.date.asString(withDateFormat: .monthYear)
               }) {
                let base = transactions.filter { 
                    $0.category == category.id &&
                    $0.date.asString(withDateFormat: .monthYear) == baseBudget.date.asString(withDateFormat: .monthYear)
                }.map { $0.amount }.reduce(.zero, +)
                
                viewData.base = base
                viewData.budgetBase = budget.amount
            }
            
            if compareCategories.contains(where: { $0.id == category.id }),
               let budget = budgets.first(where: {
                   $0.category == category.id &&
                   $0.date.asString(withDateFormat: .monthYear) == compareBudget.date.asString(withDateFormat: .monthYear)
               }) {
                let compare = transactions.filter {
                    $0.category == category.id &&
                    $0.date.asString(withDateFormat: .monthYear) == compareBudget.date.asString(withDateFormat: .monthYear)
                }.map { $0.amount }.reduce(.zero, +)
                
                viewData.compare = compare
                viewData.budgetCompare = budget.amount
            }
            
            return viewData.budgetBase == .zero && viewData.budgetCompare == .zero ? nil : viewData
        }
    }
    
    private func getTagsChart(
        baseBudget: BudgetRowViewDataProtocol,
        compareBudget: BudgetRowViewDataProtocol,
        budgets: [BudgetModelProtocol],
        tags: [TagModelProtocol],
        transactions: [TransactionModelProtocol]
    ) -> [BudgetComparisonChartViewDataProtocol] {
        tags.compactMap { tag in
            let base = transactions.filter {
                $0.message
                    .folding(options: .diacriticInsensitive, locale: .current)
                    .lowercased()
                    .contains(
                        tag.name
                            .folding(options: .diacriticInsensitive, locale: .current)
                            .lowercased()
                    ) &&
                $0.date.asString(withDateFormat: .monthYear) == baseBudget.date.asString(withDateFormat: .monthYear)
            }.map { $0.amount }.reduce(.zero, +)
            
            let compare = transactions.filter {
                $0.message
                    .folding(options: .diacriticInsensitive, locale: .current)
                    .lowercased()
                    .contains(
                        tag.name
                            .folding(options: .diacriticInsensitive, locale: .current)
                            .lowercased()
                    ) &&
                $0.date.asString(withDateFormat: .monthYear) == compareBudget.date.asString(withDateFormat: .monthYear)
            }.map { $0.amount }.reduce(.zero, +)
            
            guard compare > .zero || base > .zero else { return nil }
            
            return BudgetComparisonChartViewData(
                icon: RefdsIconSymbol(rawValue: tag.icon),
                color: Color(hex: tag.color),
                domain: tag.name.capitalized,
                base: base,
                compare: compare,
                budgetBase: .zero,
                budgetCompare: .zero
            )
        }
    }
}
