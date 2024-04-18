import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class BalanceMiddleware<State>: RefdsReduxMiddlewareProtocol {
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
        case let .fetchData(date): 
            let balance = getCurrentBalance(from: date)
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
            let balance = getCurrentBalance(from: date, id: categoryId, searchText: searchText)
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
        case let .fetchData(date, searchText):
            let balance = getCurrentBalance(from: date, searchText: searchText)
            completion(.updateBalance(balance))
        default:
            break
        }
    }
    
    private func getCurrentBalance(from date: Date?, searchText: String = "") -> BalanceRowViewDataProtocol {
        guard let date = date else {
            var transactions = transactionRepository.getTransactions()
            
            if !searchText.isEmpty {
                transactions = transactions.filter {
                    $0.amount.asString.lowercased().contains(searchText.lowercased()) || $0.message.lowercased().contains(searchText.lowercased())
                }
            }
            
            let expense = transactions.map { $0.amount }.reduce(.zero, +)
            let budget = categoryRepository.getAllBudgets().map { $0.amount }.reduce(.zero, +)
            let balance = BalanceRowViewData(
                title: .localizable(by: .categoriesBalanceTitle),
                subtitle: .localizable(by: .categoriesBalanceSubtitle),
                expense: expense,
                income: .zero,
                budget: budget
            )
            return balance
        }
        
        var transactions = transactionRepository.getTransactions(from: date, format: .monthYear)
        
        if !searchText.isEmpty {
            transactions = transactions.filter {
                $0.amount.asString.lowercased().contains(searchText.lowercased()) || $0.message.lowercased().contains(searchText.lowercased())
            }
        }
        
        let expense = transactions.map { $0.amount }.reduce(.zero, +)
        let budget = categoryRepository.getBudgets(from: date).map { $0.amount }.reduce(.zero, +)
        let balance = BalanceRowViewData(
            title: .localizable(by: .categoriesBalanceTitle),
            subtitle: .localizable(by: .categoriesBalanceSubtitle),
            expense: expense,
            income: .zero,
            budget: budget
        )
        return balance
    }
    
    private func getCurrentBalance(from date: Date?, id: UUID, searchText: String) -> BalanceRowViewDataProtocol {
        let category = categoryRepository.getCategory(by: id)
        
        guard let date = date else {
            var transactions = transactionRepository.getTransactions(on: id)
            
            if !searchText.isEmpty {
                transactions = transactions.filter {
                    $0.amount.asString.lowercased().contains(searchText.lowercased()) ||
                    $0.message.lowercased().contains(searchText.lowercased())
                }
            }
            
            let expense = transactions.map { $0.amount }.reduce(.zero, +)
            let budget = categoryRepository.getBudgets(on: id).map { $0.amount }.reduce(.zero, +)
            let balance = BalanceRowViewData(
                title: .localizable(by: .categoryBalanceTitle, with: category?.name ?? ""),
                subtitle: .localizable(by: .categoryBalanceSubtitle, with: category?.name ?? ""),
                expense: expense,
                income: .zero,
                budget: budget
            )
            return balance
        }

        var transactions = transactionRepository.getTransactions(on: id, from: date, format: .monthYear)
        
        if !searchText.isEmpty {
            transactions = transactions.filter {
                $0.amount.asString.lowercased().contains(searchText.lowercased()) ||
                $0.message.lowercased().contains(searchText.lowercased())
            }
        }
        
        let expense = transactions.map { $0.amount }.reduce(.zero, +)
        let budget = categoryRepository.getBudget(on: id, from: date)?.amount ?? .zero
        let balance = BalanceRowViewData(
            title: .localizable(by: .categoryBalanceTitle, with: category?.name ?? ""),
            subtitle: .localizable(by: .categoryBalanceSubtitle, with: category?.name ?? ""),
            expense: expense,
            income: .zero,
            budget: budget
        )
        return balance
    }
}
