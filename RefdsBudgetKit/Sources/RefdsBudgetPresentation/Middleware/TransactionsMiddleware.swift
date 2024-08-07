import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource
import WidgetKit

public final class TransactionsMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var tagRepository: TagUseCase
    @RefdsInjection private var budgetRepository: BudgetUseCase
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    @RefdsInjection private var categoryAdapter: CategoryAdapterProtocol
    @RefdsInjection private var transactionRowViewDataAdapter: TransactionRowViewDataAdapterProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        switch action {
        case let action as TransactionsAction: self.handler(with: state.transactionsState, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: TransactionsStateProtocol,
        for action: TransactionsAction,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        switch action {
        case .fetchData:
            let date = state.isFilterEnable ? state.date : nil
            fetchData(
                with: state.searchText,
                and: state.selectedCategories,
                tagsName: state.selectedTags,
                status: state.selectedStatus,
                page: state.page,
                paginationDaysAmount: state.paginationDaysAmount,
                from: date,
                on: completion
            )
        case let .fetchTransactionForEdit(transactionId): fetchTransactionForEdit(with: transactionId, on: completion)
        case let .removeTransaction(id): removeTransaction(with: state, by: id, on: completion)
        case let .removeTransactions(ids): removeTransactions(with: state, by: ids, on: completion)
        case let .updateStatus(id): updateStatus(for: id, on: completion)
        case let .shareText(ids): shareText(for: ids, on: completion)
        case let .share(ids): share(for: ids, on: completion)
        default: break
        }
    }
    
    private func fetchData(
        with searchText: String,
        and categoriesName: Set<String>,
        tagsName: Set<String>,
        status: Set<String>,
        page: Int,
        paginationDaysAmount: Int,
        from date: Date?,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        var transactions: [TransactionModelProtocol] = []
        var categories: [CategoryModelProtocol] = []
        let tags = tagRepository.getTags().map { $0.name }
        
        if let date = date {
            transactions = transactionRepository.getTransactions(from: date, format: .monthYear)
            categories = categoryRepository.getCategories(from: date)
        } else {
            transactions = transactionRepository.getAllTransactions()
            categories = categoryRepository.getAllCategories()
        }
        
        if !categoriesName.isEmpty {
            let categoriesId = categoryRepository.getAllCategories().filter { categoriesName.contains($0.name) }.map { $0.id }
            transactions = transactions.filter { categoriesId.contains($0.category) }
        }
        
        if !tagsName.isEmpty {
            transactions = transactions.filter { transaction in
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
        
        if !searchText.isEmpty {
            transactions = transactions.filter {
                $0.amount.asString.lowercased().contains(searchText.lowercased()) ||
                $0.message.lowercased().contains(searchText.lowercased())
            }
        }
        
        if !status.isEmpty {
            transactions = transactions.filter {
                status.contains(TransactionStatus(rawValue: $0.status)?.description ?? "")
            }
        }
        
        let transactionsAdapted: [TransactionRowViewDataProtocol] = transactions.compactMap {
            guard let category = categoryRepository.getCategory(by: $0.category) else { return nil }
            return transactionRowViewDataAdapter.adapt(
                model: $0,
                categoryModel: category
            )
        }
        
        let groupedTransactions = Dictionary(
            grouping: transactionsAdapted,
            by: { $0.date.asString(withDateFormat: .dayMonthYear) }
        ).map({ $0.value }).sorted(by: {
            ($0.first?.date ?? Date()) >=
            ($1.first?.date ?? Date())
        })
        
        if let range: ClosedRange<Int> = .range(
            page: page,
            amount: paginationDaysAmount,
            count: groupedTransactions.indices.count
        ) {
            let filteredTransactions = Array(groupedTransactions[range])
            let canChangePage = page * filteredTransactions.count < groupedTransactions.count
            completion(.updateData(
                transactions: filteredTransactions,
                categories: categories.map { $0.name },
                tags: tags,
                page: page,
                canChangePage: canChangePage
            ))
        } else {
            completion(.updateData(
                transactions: [],
                categories: categories.map { $0.name },
                tags: tags,
                page: page,
                canChangePage: false
            ))
        }
    }
    
    private func fetchTransactionForEdit(
        with id: UUID,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        guard let transaction = transactionRepository.getTransaction(by: id) else {
            return completion(.updateError(.notFoundTransaction))
        }
        
        let categories: [CategoryRowViewDataProtocol] = categoryRepository.getCategories(from: transaction.date.date).compactMap {
            guard let budget = budgetRepository.getBudget(on: $0.id, from: transaction.date.date) else { return nil }
            let transactions = transactionRepository.getTransactions(on: $0.id, from: transaction.date.date, format: .dayMonthYear).map { $0.amount }
            let spend = transactions.reduce(.zero, +)
            let percentage = spend / (budget.amount == .zero ? 1 : budget.amount)
            return categoryAdapter.adapt(
                model: $0,
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
    
    private func removeTransaction(
        with state: TransactionsStateProtocol,
        by id: UUID,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        do {
            try transactionRepository.removeTransaction(by: id)
        } catch { completion(.updateError(.notFoundTransaction)) }
        WidgetCenter.shared.reloadAllTimelines()
        completion(.fetchData)
    }
    
    private func removeTransactions(
        with state: TransactionsStateProtocol,
        by ids: Set<UUID>,
        on completion: @escaping (TransactionsAction) -> Void
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
        on completion: @escaping (TransactionsAction) -> Void
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
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        let text = FileFactory.shared.getTransactionsText(for: ids)
        completion(.updateShareText(text))
    }
    
    private func share(
        for ids: Set<UUID>,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        let url = FileFactory.shared.getFileURL(transactionsId: ids)
        completion(.updateShare(url))
    }
}
