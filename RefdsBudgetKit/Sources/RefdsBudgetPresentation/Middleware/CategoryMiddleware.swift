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
    @RefdsInjection private var categoryAdapter: CategoryAdapterProtocol
    @RefdsInjection private var budgetAdapter: BudgetAdapterProtocol
    @RefdsInjection private var budgetRowViewDataAdapter: BudgetRowViewDataAdapterProtocol
    @RefdsInjection private var transactionRowViewDataAdapter: TransactionRowViewDataAdapterProtocol
    
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
        case let .fetchData(date, categoryId, searchText): fetchData(with: categoryId, and: searchText, from: date, on: completion)
        case let .fetchBudgetForEdit(date, categoryId, budgetId): fetchBudgetForEdit(from: date, categoryId: categoryId, budgetId: budgetId, on: completion)
        case let .fetchCategoryForEdit(categoryId): fetchCategoryForEdit(with: categoryId, on: completion)
        case let .fetchTransactionForEdit(transactionId): fetchTransactionForEdit(with: transactionId, on: completion)
        case let .removeBudget(date, id): removeBudget(with: state, from: date, by: id, on: completion)
        case let .removeCategory(date, id): removeCategory(with: state, from: date, by: id, on: completion)
        case let .removeTransaction(id): removeTransaction(with: state, by: id, on: completion)
        case let .removeTransactions(ids): removeTransactions(with: state, by: ids, on: completion)
        case let .copyTransactions(ids): copyTransactions(by: ids, on: completion)
        default: break
        }
    }
    
    private func fetchData(
        with categoryId: UUID,
        and searchText: String,
        from date: Date?,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        guard let categoryEntity = categoryRepository.getCategory(by: categoryId) else {
            return completion(.updateError(.notFoundCategory))
        }
        
        var budgetsEntity: [BudgetEntity] = []
        var transactionsEntity: [TransactionEntity] = []
        
        if let date = date, let budgetEntity = categoryRepository.getBudget(on: categoryId, from: date) {
            budgetsEntity += [budgetEntity]
            transactionsEntity = transactionRepository.getTransactions(on: categoryId, from: date, format: .monthYear)
        } else if date == nil {
            budgetsEntity = categoryRepository.getBudgets(on: categoryId)
            transactionsEntity = transactionRepository.getTransactions(on: categoryId)
        }
        
        if !searchText.isEmpty {
            transactionsEntity = transactionsEntity.filter {
                $0.amount.currency().lowercased().contains(searchText.lowercased()) ||
                $0.message.lowercased().contains(searchText.lowercased())
            }
        }
        
        let budgets = budgetsEntity.map { budget in
            let transactionsAmount = transactionsEntity.filter {
                $0.date.asString(withDateFormat: .monthYear) ==
                budget.date.asString(withDateFormat: .monthYear)
            }.map { $0.amount }.reduce(.zero, +)
            let percentage = transactionsAmount / (budget.amount == .zero ? 1 : budget.amount)
            return budgetRowViewDataAdapter.adapt(budgetEntity: budget, percentage: percentage)
        }
        
        let transactions = transactionsEntity.map {
            transactionRowViewDataAdapter.adapt(
                transactionEntity: $0,
                categoryEntity: categoryEntity
            )
        }
        
        let groupedTransactions = Dictionary(
            grouping: transactions,
            by: { $0.date.asString(withDateFormat: .dayMonthYear) }
        ).map({ $0.value }).sorted(by: {
            ($0.first?.date ?? Date()) >=
            ($1.first?.date ?? Date())
        })
        
        return completion(
            .updateData(
                name: categoryEntity.name,
                icon: categoryEntity.icon,
                color: Color(hex: categoryEntity.color),
                budgets: budgets,
                transactions: groupedTransactions
            )
        )
    }
    
    private func fetchBudgetForEdit(
        from date: Date,
        categoryId: UUID,
        budgetId: UUID,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        let categories = categoryRepository.getAllCategories().map {
            categoryAdapter.adapt(entity: $0)
        }
        
        guard let categoryEntity = categoryRepository.getCategory(by: categoryId) else {
            return completion(.updateError(.notFoundCategory))
        }
        
        let entity = categoryRepository.getBudget(by: budgetId)
        let state = budgetAdapter.adapt(
            entity: entity,
            category: categoryAdapter.adapt(entity: categoryEntity),
            categories: categories
        )
        
        completion(.editBudget(state, date))
    }
    
    private func fetchCategoryForEdit(
        with id: UUID,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        guard let category = categoryRepository.getCategory(by: id) else {
            return completion(.updateError(.notFoundCategory))
        }
        completion(.editCategory(categoryAdapter.adapt(entity: category)))
    }
    
    private func fetchTransactionForEdit(
        with id: UUID,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        guard let transaction = transactionRepository.getTransaction(by: id) else {
            return completion(.updateError(.notFoundTransaction))
        }
        
        let categories: [CategoryRowViewDataProtocol] = categoryRepository.getCategories(from: transaction.date.date).compactMap {
            guard let budget = categoryRepository.getBudget(on: $0.id, from: transaction.date.date) else { return nil }
            let transactions = transactionRepository.getTransactions(on: $0.id, from: transaction.date.date, format: .dayMonthYear).map { $0.amount }
            let spend = transactions.reduce(.zero, +)
            let percentage = spend / (budget.amount == .zero ? 1 : budget.amount)
            return categoryAdapter.adapt(
                entity: $0,
                budgetId: budget.id,
                budgetDescription: budget.message,
                budget: budget.amount,
                percentage: percentage,
                transactionsAmount: 1,
                spend: spend
            )
        }
        
        guard let category = categories.first(where: { $0.categoryId == transaction.category }) else {
            return completion(.updateError(.notFoundCategory))
        }
        
        let viewData = AddTransactionState(
            id: transaction.id,
            amount: transaction.amount,
            description: transaction.message,
            category: category,
            categories: categories,
            remaining: nil,
            date: transaction.date.date,
            error: nil
        )
        
        completion(.addTransaction(viewData))
    }
    
    private func removeBudget(
        with state: CategoryStateProtocol,
        from date: Date,
        by id: UUID,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        guard let budgetEntity = categoryRepository.getBudget(by: id) else {
            return completion(.updateError(.notFoundBudget))
        }
        
        guard let category = categoryRepository.getCategory(by: budgetEntity.category) else {
            return completion(.updateError(.notFoundCategory))
        }
        
        let categoryId = category.id
        
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
        
        completion(
            .fetchData(
                date,
                categoryId,
                state.searchText
            )
        )
    }
    
    private func removeCategory(
        with state: CategoryStateProtocol,
        from date: Date?,
        by id: UUID,
        on completion: @escaping (CategoryAction) -> Void
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
        
        completion(
            .fetchData(
                state.isFilterEnable ? state.date : nil,
                id,
                state.searchText
            )
        )
    }
    
    private func removeTransaction(
        with state: CategoryStateProtocol,
        by id: UUID,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        do {
            try transactionRepository.removeTransaction(by: id)
        } catch { completion(.updateError(.notFoundTransaction)) }
        
        completion(
            .fetchData(
                state.isFilterEnable ? state.date : nil,
                state.id,
                state.searchText
            )
        )
    }
    
    private func removeTransactions(
        with state: CategoryStateProtocol,
        by ids: Set<UUID>,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        ids.forEach { id in
            try? transactionRepository.removeTransaction(by: id)
        }
        completion(
            .fetchData(
                state.isFilterEnable ? state.date : nil,
                state.id,
                state.searchText
            )
        )
    }
    
    private func copyTransactions(
        by ids: Set<UUID>,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        var transactions = ""
        var total: Double = .zero
        var count: Int = .zero
        var startDate: TimeInterval = Date().timestamp
        var endDate: TimeInterval = .zero
    
        ids.forEach { id in
            if let transaction = transactionRepository.getTransaction(by: id) {
                let category = categoryRepository.getCategory(by: transaction.category)
                total += transaction.amount
                count += 1
                if transaction.date < startDate { startDate = transaction.date }
                if transaction.date > endDate { endDate = transaction.date }
                
                transactions += """
                • \(transaction.amount.currency()) - \(transaction.date.asString(withDateFormat: .dayMonthYear))
                \(category?.name ?? "") - \(transaction.message)\n\n
                """
            }
        }
        
        transactions = .localizable(by: .transactionsCopyHeader, with: count, startDate.asString(), endDate.asString()) + transactions
        transactions += .localizable(by: .transactionsCopyFooter, with: total.currency())
        
        #if os(macOS)
        NSPasteboard.general.setString(transactions, forType: .string)
        #elseif os(iOS)
        UIPasteboard.general.string = transactions
        #endif
    }
}
