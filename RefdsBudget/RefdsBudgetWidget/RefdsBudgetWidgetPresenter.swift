import Foundation
import SwiftUI
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetPresentation

protocol RefdsBudgetWidgetPresenterProtocol {
    func getSystemSmallExpenseTrackerViewData(
        isFilterByDate: Bool,
        category: String,
        tag: String
    ) -> SystemSmallExpenseTrackerViewDataProtocol
    func getSystemSmallTransactionsViewData(
        isFilterByDate: Bool,
        category: String,
        tag: String
    ) -> SystemSmallTransactionsViewDataProtocol
    func getCategories() -> [String]
    func getTags() -> [String]
}

final class RefdsBudgetWidgetPresenter: RefdsBudgetWidgetPresenterProtocol {
    private let categoryRepository: CategoryUseCase
    private let transactionsRepository: TransactionUseCase
    private let tagRepository: BubbleUseCase
    
    public init() {
        RefdsContainer.register(type: RefdsBudgetDatabaseProtocol.self) { RefdsBudgetDatabase() }
        categoryRepository = LocalCategoryRepository()
        transactionsRepository = LocalTransactionRepository()
        tagRepository = LocalBubbleRepository()
    }
    
    func getSystemSmallExpenseTrackerViewData(
        isFilterByDate: Bool,
        category: String,
        tag: String
    ) -> SystemSmallExpenseTrackerViewDataProtocol {
        var budgets: [BudgetEntity] = []
        var transactions: [TransactionEntity] = []
        
        if isFilterByDate {
            transactions = transactionsRepository.getTransactions(from: .current, format: .monthYear)
            budgets = categoryRepository.getBudgets(from: .current)
        } else {
            transactions = transactionsRepository.getTransactions()
            budgets = categoryRepository.getAllBudgets()
        }
        
        if category != String.localizable(by: .transactionsCategorieAllSelected) {
            transactions = transactions.filter {
                let entity = categoryRepository.getCategory(by: $0.category)
                return entity?.name.lowercased() == category.lowercased()
            }
            
            budgets = budgets.filter {
                let entity = categoryRepository.getCategory(by: $0.category)
                return entity?.name.lowercased() == category.lowercased()
            }
        }
        
        if tag != String.localizable(by: .transactionsCategorieAllSelected) {
            transactions = transactions.filter {
                $0.message.lowercased().contains(tag.lowercased())
            }
        }
        
        return SystemSmallExpenseTrackerViewData(
            isFilterByDate: isFilterByDate,
            category: category,
            tag: tag,
            date: .current,
            spend: transactions.map { $0.amount }.reduce(.zero, +),
            budget: budgets.map { $0.amount }.reduce(.zero, +)
        )
    }
    
    func getSystemSmallTransactionsViewData(
        isFilterByDate: Bool,
        category: String,
        tag: String
    ) -> SystemSmallTransactionsViewDataProtocol {
        var budgets: [BudgetEntity] = []
        var transactions: [TransactionEntity] = []
        
        if isFilterByDate {
            transactions = transactionsRepository.getTransactions(from: .current, format: .monthYear)
            budgets = categoryRepository.getBudgets(from: .current)
        } else {
            transactions = transactionsRepository.getTransactions()
            budgets = categoryRepository.getAllBudgets()
        }
        
        if category != String.localizable(by: .transactionsCategorieAllSelected) {
            transactions = transactions.filter {
                let entity = categoryRepository.getCategory(by: $0.category)
                return entity?.name.lowercased() == category.lowercased()
            }
            
            budgets = budgets.filter {
                let entity = categoryRepository.getCategory(by: $0.category)
                return entity?.name.lowercased() == category.lowercased()
            }
        }
        
        if tag != String.localizable(by: .transactionsCategorieAllSelected) {
            transactions = transactions.filter {
                $0.message.lowercased().contains(tag.lowercased())
            }
        }
        
        let transactionsAdapted: [TransactionRowViewDataProtocol] = transactions.compactMap { transaction in
            guard let category = categoryRepository.getCategory(by: transaction.category) else { return nil }
            return TransactionRowViewData(
                id: transaction.id,
                icon: category.icon,
                color: Color(hex: category.color),
                amount: transaction.amount,
                description: transaction.message,
                date: transaction.date.date
            )
        }
        
        return SystemSmallTransactionsViewData(
            isFilterByDate: isFilterByDate,
            category: category,
            tag: tag,
            date: .current,
            spend: transactions.map { $0.amount }.reduce(.zero, +),
            transactions: transactionsAdapted,
            amount: transactionsAdapted.count
        )
    }
    
    func getCategories() -> [String] {
        categoryRepository.getAllCategories().map { $0.name } +
        [String.localizable(by: .transactionsCategorieAllSelected)]
    }
    
    func getTags() -> [String] {
        tagRepository.getBubbles().map { $0.name } +
        [String.localizable(by: .transactionsCategorieAllSelected)]
    }
}
