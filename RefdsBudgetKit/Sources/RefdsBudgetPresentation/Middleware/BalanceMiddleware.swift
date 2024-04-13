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
        default: break
        }
    }
    
    private func handler(
        for action: CategoriesAction,
        on completion: (CategoriesAction) -> Void
    ) {
        switch action {
        case let .fetchData(date):
            guard let date = date else {
                let expense = transactionRepository.getTransactions().map { $0.amount }.reduce(.zero, +)
                let budget = categoryRepository.getAllBudgets().map { $0.amount }.reduce(.zero, +)
                let balance = BalanceState(
                    title: .localizable(by: .categoriesBalanceTitle),
                    subtitle: .localizable(by: .categoriesBalanceSubtitle),
                    expense: expense,
                    income: .zero,
                    budget: budget
                )
                return completion(.updateBalance(balance))
            }
            
            let expense = transactionRepository.getTransactions(from: date, format: .monthYear).map { $0.amount }.reduce(.zero, +)
            let budget = categoryRepository.getBudgets(from: date).map { $0.amount }.reduce(.zero, +)
            let balance = BalanceState(
                title: .localizable(by: .categoriesBalanceTitle),
                subtitle: .localizable(by: .categoriesBalanceSubtitle),
                expense: expense,
                income: .zero,
                budget: budget
            )
            completion(.updateBalance(balance))
        
        default:
            break
        }
    }
}
