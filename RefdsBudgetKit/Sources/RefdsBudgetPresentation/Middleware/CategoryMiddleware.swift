import Foundation
import SwiftUI
import WidgetKit
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
        case .fetchData:
            let date = state.isFilterEnable ? state.date : nil
            fetchData(
                with: state.id,
                and: state.searchText,
                page: state.page,
                from: date,
                on: completion
            )
        case let .fetchBudgetForEdit(date, categoryId, budgetId): fetchBudgetForEdit(from: date, categoryId: categoryId, budgetId: budgetId, on: completion)
        case let .fetchCategoryForEdit(categoryId): fetchCategoryForEdit(with: categoryId, on: completion)
        case let .fetchTransactionForEdit(transactionId): fetchTransactionForEdit(with: transactionId, on: completion)
        case let .removeBudget(date, id): removeBudget(with: state, from: date, by: id, on: completion)
        case let .removeCategory(date, id): removeCategory(with: state, from: date, by: id, on: completion)
        case let .removeTransaction(id): removeTransaction(with: state, by: id, on: completion)
        case let .removeTransactions(ids): removeTransactions(with: state, by: ids, on: completion)
        case let .updateStatus(id): updateStatus(for: id, on: completion)
        case let .shareText(ids): shareText(for: ids, on: completion)
        case let .share(ids): share(for: ids, on: completion)
        default: break
        }
    }
    
    private func fetchData(
        with categoryId: UUID,
        and searchText: String,
        page: Int,
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
                let status = TransactionStatus(rawValue: $0.status)
                return ($0.date.asString(withDateFormat: .monthYear) ==
                budget.date.asString(withDateFormat: .monthYear)) &&
                status != .pending && status != .cleared
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
        
        if date == nil {
            if let range: ClosedRange<Int> = .range(
                page: page,
                amount: 15,
                count: groupedTransactions.indices.count
            ) {
                let filteredTransactions = Array(groupedTransactions[range])
                let canChangePage = (page + 1) * filteredTransactions.count < groupedTransactions.count
                return completion(
                    .updateData(
                        name: categoryEntity.name,
                        icon: categoryEntity.icon,
                        color: Color(hex: categoryEntity.color),
                        budgets: budgets,
                        transactions: filteredTransactions,
                        page: page,
                        canChangePage: canChangePage
                    )
                )
            } else {
                return completion(
                    .updateData(
                        name: categoryEntity.name,
                        icon: categoryEntity.icon,
                        color: Color(hex: categoryEntity.color),
                        budgets: budgets,
                        transactions: [],
                        page: page,
                        canChangePage: false
                    )
                )
            }
        }
        
        completion(
            .updateData(
                name: categoryEntity.name,
                icon: categoryEntity.icon,
                color: Color(hex: categoryEntity.color),
                budgets: budgets,
                transactions: groupedTransactions,
                page: 1,
                canChangePage: false
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
        
        if let categoryEntity = categoryRepository.getCategory(by: categoryId) {
            let entity = categoryRepository.getBudget(by: budgetId)
            let state = budgetAdapter.adapt(
                entity: entity,
                category: categoryAdapter.adapt(entity: categoryEntity),
                categories: categories
            )
            
            completion(.editBudget(state, date))
        } else { completion(.updateError(.notFoundCategory)) }
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
            status: TransactionStatus(rawValue: transaction.status) ?? .spend,
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
        
        do {
            try categoryRepository.removeBudget(id: budgetEntity.id)
            WidgetCenter.shared.reloadAllTimelines()
            completion(.fetchData)
        } catch { 
            completion(.updateError(.cantDeleteBudget))
        }
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
        
        WidgetCenter.shared.reloadAllTimelines()
        completion(.dismiss)
    }
    
    private func removeTransaction(
        with state: CategoryStateProtocol,
        by id: UUID,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        do {
            try transactionRepository.removeTransaction(by: id)
        } catch { completion(.updateError(.notFoundTransaction)) }
        
        WidgetCenter.shared.reloadAllTimelines()
        completion(.fetchData)
    }
    
    private func removeTransactions(
        with state: CategoryStateProtocol,
        by ids: Set<UUID>,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        do {
            try transactionRepository.removeTransactions(by: Array(ids))
            WidgetCenter.shared.reloadAllTimelines()
            completion(.fetchData)
        } catch {
            completion(.updateError(.notFoundTransaction))
        }
    }
    
    private func updateStatus(
        for id: UUID,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        guard let transaction = transactionRepository.getTransaction(by: id) else {
            return completion(.updateError(.notFoundTransaction))
        }
        var status = TransactionStatus(rawValue: transaction.status) ?? .spend
        status = status == .pending ? .cleared : status == .cleared ? .pending : .spend
        
        do {
            try transactionRepository.addTransaction(
                id: transaction.id,
                date: transaction.date.date,
                message: transaction.message,
                category: transaction.category,
                amount: transaction.amount,
                status: status
            )
            WidgetCenter.shared.reloadAllTimelines()
            completion(.fetchData)
        } catch {
            completion(.updateError(.cantSaveOnDatabase))
        }
    }
    
    private func shareText(
        for ids: Set<UUID>,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        let text = FileFactory.shared.getTransactionsText(for: ids)
        completion(.updateShareText(text))
    }
    
    private func share(
        for ids: Set<UUID>,
        on completion: @escaping (CategoryAction) -> Void
    ) {
        let url = FileFactory.shared.getFileURL(transactionsId: ids)
        completion(.updateShare(url))
    }
}
