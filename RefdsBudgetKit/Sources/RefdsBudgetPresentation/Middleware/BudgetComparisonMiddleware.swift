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
    @RefdsInjection private var transactionRepository: TransactionUseCase
    @RefdsInjection private var intelligence: IntelligenceProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        switch action {
        case let action as BudgetComparisonAction: self.handler(
            with: state.budgetComparisonState,
            for: action,
            on: completion
        )
        default: break
        }
    }
    
    private func handler(
        with state: BudgetComparisonStateProtocol,
        for action: BudgetComparisonAction,
        on completion: @escaping (BudgetComparisonAction) -> Void
    ) {
        switch action {
        case .fetchData: 
            fetchData(
                with: state,
                on: completion
            )
        default: break
        }
    }
    
    private func fetchData(
        with state: BudgetComparisonStateProtocol,
        on completion: @escaping (BudgetComparisonAction) -> Void
    ) {
        let budgets = getBudgets()
        guard let baseBudgetDate = state.baseBudgetDate,
              let compareBudgetDate = state.hasAI ? baseBudgetDate : state.compareBudgetDate,
              (baseBudgetDate == compareBudgetDate && state.hasAI) || (baseBudgetDate != compareBudgetDate)
        else { return }
        guard let baseBudget = budgets.first(where: { $0.date.asString(withDateFormat: .monthYear) == baseBudgetDate }),
              let compareBudget = budgets.first(where: { $0.date.asString(withDateFormat: .monthYear) == compareBudgetDate })
        else { return }
        
        var baseBudgetSorted = baseBudget.date < compareBudget.date ? baseBudget : compareBudget
        baseBudgetSorted.hasAI = state.hasAI
        
        let compareBudgetSorted = baseBudget.date < compareBudget.date ? compareBudget : baseBudget
        
        if baseBudgetSorted.hasAI {
            let categories = categoryRepository.getCategories(from: baseBudgetSorted.date)
            
            baseBudgetSorted.amount = categories.compactMap {
                intelligence.predict(
                    for: .budgetFromBudgets(date: baseBudgetSorted.date, category: $0.id),
                    with: .budgetFromBudgets(baseBudgetSorted.date),
                    on: .custom
                )
            }.reduce(.zero, +)
            
            baseBudgetSorted.spend = categories.compactMap {
                intelligence.predict(
                    for: .budgetFromTransactions(date: baseBudgetSorted.date, category: $0.id),
                    with: .budgetFromTransactions(baseBudgetSorted.date),
                    on: .custom
                )
            }.reduce(.zero, +)
            
            baseBudgetSorted.percentage = baseBudgetSorted.spend / (baseBudgetSorted.amount == .zero ? 1 : baseBudgetSorted.amount)
        }
        
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
        let transactionModels = transactionRepository.getAllTransactions()
        
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
    
    private func getBudgets() -> [BudgetRowViewDataProtocol] {
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
        
        return budgetsGroup.flatMap { $0 }
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
            
            if baseCategories.contains(where: { $0.id == category.id }) {
                if baseBudget.hasAI {
                    let base = intelligence.predict(
                        for: .budgetFromTransactions(date: baseBudget.date, category: category.id),
                        with: .budgetFromTransactions(baseBudget.date),
                        on: .custom
                    ) ?? .zero
                    
                    let amount = intelligence.predict(
                        for: .budgetFromBudgets(date: baseBudget.date, category: category.id),
                        with: .budgetFromBudgets(baseBudget.date),
                        on: .custom
                    ) ?? .zero
                    
                    viewData.base = base
                    viewData.budgetBase = amount
                } else if let budget = budgets.first(where: {
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
            var base: Double = .zero
            if baseBudget.hasAI {
                base = intelligence.predict(
                    for: .transactionsFromTags(date: baseBudget.date, tag: tag.name),
                    with: .transactionsFromTags(baseBudget.date),
                    on: .custom
                ) ?? .zero
            } else {
                base = transactions.filter {
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
            }
            
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
