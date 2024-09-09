import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class BalanceMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var tagRepository: TagUseCase
    @RefdsInjection private var budgetRepository: BudgetUseCase
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        switch action {
        case let action as CategoriesAction:
            self.handler(with: state.categoriesState, for: action, on: completion)
        case let action as TransactionsAction:
            self.handler(with: state.transactionsState, for: action, on: completion)
        case let action as HomeAction:
            self.handler(with: state.homeState, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: CategoriesStateProtocol,
        for action: CategoriesAction,
        on completion: (CategoriesAction) -> Void
    ) {
        switch action {
        case .fetchData:
            let date = state.filter.isDateFilter ? state.filter.date : nil
            let balance = getCurrentBalance(
                from: date,
                selectedItems: state.filter.selectedItems
            )
            completion(.updateBalance(balance))
        default:
            break
        }
    }
    
    private func handler(
        with state: TransactionsStateProtocol,
        for action: TransactionsAction,
        on completion: (TransactionsAction) -> Void
    ) {
        switch action {
        case .fetchData:
            let date = state.filter.isDateFilter ? state.filter.date : nil
            let balance = getCurrentBalance(
                from: date,
                selectedItems: state.filter.selectedItems,
                searchText: state.filter.searchText
            )
            completion(.updateBalance(balance))
        default:
            break
        }
    }
    
    private func handler(
        with state: HomeStateProtocol,
        for action: HomeAction,
        on completion: (HomeAction) -> Void
    ) {
        switch action {
        case .fetchData:
            let date = state.filter.isDateFilter ? state.filter.date : nil
            let balance = getCurrentBalance(
                from: date,
                selectedItems: state.filter.selectedItems
            )
            var remainingBalance = balance
            remainingBalance.expense = balance.budget - balance.expense
            remainingBalance.title = .localizable(by: .homeRemainingTitle)
            completion(
                .updateBalance(
                    balance: balance,
                    remainingBalace: remainingBalance
                )
            )
        default:
            break
        }
    }
    
    private func getCurrentBalance(
        from date: Date?,
        selectedItems: Set<String> = [],
        searchText: String = "",
        title: String = .localizable(by: .categoriesBalanceTitle),
        subititle: String = .localizable(by: .categoriesBalanceSubtitle)
    ) -> BalanceRowViewDataProtocol {
        var transactions: [TransactionModelProtocol] = []
        var budgets: [BudgetModelProtocol] = []
        let status = TransactionStatus.allCases.filter { selectedItems.contains($0.description) }
        
        if let date = date {
            transactions = transactionRepository.getTransactions(from: date, format: .monthYear).filter {
                status.isEmpty ? $0.status != TransactionStatus.pending.rawValue &&
                $0.status != TransactionStatus.cleared.rawValue : true
            }
            budgets = budgetRepository.getBudgets(from: date)
        } else {
            transactions = transactionRepository.getAllTransactions().filter {
                status.isEmpty ? $0.status != TransactionStatus.pending.rawValue &&
                    $0.status != TransactionStatus.cleared.rawValue : true
            }
            budgets = budgetRepository.getAllBudgets()
        }
        
        if !selectedItems.isEmpty {
            let status = TransactionStatus.allCases.filter { selectedItems.contains($0.description) }.map { $0.rawValue }
            if !status.isEmpty {
                transactions = transactions.filter { status.contains($0.status) }
            }
            
            let categoriesId = categoryRepository.getAllCategories().filter { selectedItems.contains($0.name) }.map { $0.id }
            if !categoriesId.isEmpty {
                transactions = transactions.filter { categoriesId.contains($0.category) }
            }
            
            let tags = tagRepository.getTags().filter { selectedItems.contains($0.name) }
            if !tags.isEmpty {
                transactions = transactions.filter { transaction in
                    var contains = true
                    for tag in tags {
                        if !transaction.message
                            .folding(options: .diacriticInsensitive, locale: .current)
                            .lowercased()
                            .contains(
                                tag.name
                                    .folding(options: .diacriticInsensitive, locale: .current)
                                    .lowercased()
                            ) {
                            contains = false
                        }
                    }
                    return contains
                }
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
            budget: budget,
            amount: transactions.count
        )
        return balance
    }
}
