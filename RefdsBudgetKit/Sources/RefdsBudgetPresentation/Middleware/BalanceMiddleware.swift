import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class BalanceMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var tagRepository: BubbleUseCase
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { _, action, completion in
        switch action {
        case let action as CategoriesAction:
            self.handler(for: action, on: completion)
        case let action as CategoryAction:
            self.handler(for: action, on: completion)
        case let action as TransactionsAction:
            self.handler(for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        for action: CategoriesAction,
        on completion: (CategoriesAction) -> Void
    ) {
        switch action {
        case let .fetchData(date, tagsName):
            let balance = getCurrentBalance(from: date, tagsName: tagsName)
            completion(.updateBalance(balance))
        default:
            break
        }
    }
    
    private func handler(
        for action: CategoryAction,
        on completion: (CategoryAction) -> Void
    ) {
        switch action {
        case let .fetchData(date, categoryId, searchText):
            let balance = getCurrentBalance(
                from: date,
                and: [categoryId],
                searchText: searchText
            )
            completion(.updateBalance(balance))
        default:
            break
        }
    }
    
    private func handler(
        for action: TransactionsAction,
        on completion: (TransactionsAction) -> Void
    ) {
        switch action {
        case let .fetchData(date, searchText, categoriesName, tagsName):
            let ids = categoryRepository.getAllCategories().filter { categoriesName.contains($0.name) }.map { $0.id }
            let balance = getCurrentBalance(from: date, and: Set(ids), tagsName: tagsName, searchText: searchText)
            completion(.updateBalance(balance))
        default:
            break
        }
    }
    
    private func getCurrentBalance(
        from date: Date?,
        and categoryIds: Set<UUID> = [],
        tagsName: Set<String> = [],
        searchText: String = "",
        title: String = .localizable(by: .categoriesBalanceTitle),
        subititle: String = .localizable(by: .categoriesBalanceSubtitle)
    ) -> BalanceRowViewDataProtocol {
        var transactions: [TransactionEntity] = []
        var budgets: [BudgetEntity] = []
        
        if let date = date {
            transactions = transactionRepository.getTransactions(from: date, format: .monthYear)
            budgets = categoryRepository.getBudgets(from: date)
        } else {
            transactions = transactionRepository.getTransactions()
            budgets = categoryRepository.getAllBudgets()
        }
        
        if !categoryIds.isEmpty {
            transactions = transactions.filter { categoryIds.contains($0.category) }
            budgets = budgets.filter { categoryIds.contains($0.category) }
        }
        
        if !tagsName.isEmpty {
            transactions = transactions.filter { transaction in
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
        
        if !searchText.isEmpty {
            transactions = transactions.filter {
                $0.amount.asString.lowercased().contains(searchText.lowercased()) ||
                $0.message.lowercased().contains(searchText.lowercased())
            }
        }
        
        let expense = transactions.map { $0.amount }.reduce(.zero, +)
        let budget = budgets.map { $0.amount }.reduce(.zero, +)
        let balance = BalanceRowViewData(
            title: title,
            subtitle: subititle,
            expense: expense,
            income: .zero,
            budget: budget
        )
        return balance
    }
}
