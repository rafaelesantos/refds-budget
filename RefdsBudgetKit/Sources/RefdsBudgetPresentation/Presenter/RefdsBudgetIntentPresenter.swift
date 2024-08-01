import Foundation
import SwiftUI
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData

public protocol RefdsBudgetIntentPresenterProtocol {
    func getWidgetExpenseTrackerViewData(
        isFilterByDate: Bool,
        category: String,
        tag: String,
        status: String
    ) -> WidgetExpenseTrackerViewDataProtocol
    func getWidgetTransactionsViewData(
        isFilterByDate: Bool,
        category: String,
        tag: String,
        status: String
    ) -> WidgetTransactionsViewDataProtocol
    func getCategories() -> [String]
    func getTags() -> [String]
}

public final class RefdsBudgetIntentPresenter: RefdsBudgetIntentPresenterProtocol {
    public static let shared = RefdsBudgetIntentPresenter()
    
    private let budgetRepository: BudgetUseCase
    private let categoryRepository: CategoryUseCase
    private let transactionsRepository: TransactionUseCase
    private let tagRepository: TagUseCase
    
    private init() {
        RefdsContainer.register(type: RefdsBudgetDatabaseProtocol.self) { RefdsBudgetDatabase() }
        
        let transactionsRepository = TransactionRepository()
        RefdsContainer.register(type: TransactionUseCase.self) { transactionsRepository }
        
        let budgetRepository = BudgetRepository()
        RefdsContainer.register(type: BudgetUseCase.self) { budgetRepository }
        
        self.budgetRepository = budgetRepository
        self.transactionsRepository = transactionsRepository
        self.categoryRepository = CategoryRepository()
        tagRepository = TagRepository()
    }
    
    public func getWidgetExpenseTrackerViewData(
        isFilterByDate: Bool,
        category: String,
        tag: String,
        status: String
    ) -> WidgetExpenseTrackerViewDataProtocol {
        var budgets: [BudgetModelProtocol] = []
        var transactions: [TransactionModelProtocol] = []
        
        if isFilterByDate {
            transactions = transactionsRepository.getTransactions(from: .current, format: .monthYear).filter {
                if status == .localizable(by: .transactionsCategorieAllSelected) {
                    return $0.status != TransactionStatus.pending.rawValue &&
                    $0.status != TransactionStatus.cleared.rawValue
                } else {
                    return status == TransactionStatus(rawValue: $0.status)?.description
                }
            }
            budgets = budgetRepository.getBudgets(from: .current)
        } else {
            transactions = transactionsRepository.getAllTransactions().filter {
                if status == .localizable(by: .transactionsCategorieAllSelected) {
                    return true
                } else {
                    return status == TransactionStatus(rawValue: $0.status)?.description
                }
            }
            budgets = budgetRepository.getAllBudgets()
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
        
        return WidgetExpenseTrackerViewData(
            isFilterByDate: isFilterByDate,
            category: category,
            tag: tag,
            status: status,
            date: .current,
            spend: transactions.map { $0.amount }.reduce(.zero, +),
            budget: budgets.map { $0.amount }.reduce(.zero, +)
        )
    }
    
    public func getWidgetTransactionsViewData(
        isFilterByDate: Bool,
        category: String,
        tag: String,
        status: String
    ) -> WidgetTransactionsViewDataProtocol {
        var budgets: [BudgetModelProtocol] = []
        var categories: [CategoryModelProtocol] = []
        var transactions: [TransactionModelProtocol] = []
        
        if isFilterByDate {
            transactions = transactionsRepository.getTransactions(from: .current, format: .monthYear).filter {
                if status == .localizable(by: .transactionsCategorieAllSelected) {
                    return $0.status != TransactionStatus.pending.rawValue &&
                    $0.status != TransactionStatus.cleared.rawValue
                } else {
                    return status == TransactionStatus(rawValue: $0.status)?.description
                }
            }
            budgets = budgetRepository.getBudgets(from: .current)
            categories = categoryRepository.getCategories(from: .current)
        } else {
            transactions = transactionsRepository.getAllTransactions().filter {
                if status == .localizable(by: .transactionsCategorieAllSelected) {
                    return true
                } else {
                    return status == TransactionStatus(rawValue: $0.status)?.description
                }
            }
            budgets = budgetRepository.getAllBudgets()
            categories = categoryRepository.getAllCategories()
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
            
            categories = categories.filter {
                $0.name.lowercased() == category.lowercased()
            }
        }
        
        if tag != String.localizable(by: .transactionsCategorieAllSelected) {
            transactions = transactions.filter {
                $0.message.lowercased().contains(tag.lowercased())
            }
        }
        
        let categoriesAdapted: [CategoryRowViewDataProtocol] = categories.compactMap { entity in
            guard let budget = budgets.first(where: { $0.category == entity.id }) else { return nil }
            let transactions = transactions.filter { $0.category == entity.id }
            let spend = transactions.map { $0.amount }.reduce(.zero, +)
            let percentage = spend / (budget.amount == .zero ? 1 : budget.amount)
            return CategoryRowViewData(
                categoryId: entity.id,
                budgetId: budget.id,
                icon: entity.icon,
                name: entity.name,
                description: budget.message,
                color: Color(hex: entity.color),
                budget: budget.amount,
                percentage: percentage,
                transactionsAmount: transactions.count,
                spend: spend
            )
        }
        
        let transactionsAdapted: [TransactionRowViewDataProtocol] = transactions.compactMap { transaction in
            guard let category = categoryRepository.getCategory(by: transaction.category) else { return nil }
            return TransactionRowViewData(
                id: transaction.id,
                icon: category.icon,
                color: Color(hex: category.color),
                amount: transaction.amount,
                description: transaction.message,
                date: transaction.date.date,
                status: TransactionStatus(rawValue: transaction.status) ?? .spend
            )
        }
        
        return WidgetTransactionsViewData(
            isFilterByDate: isFilterByDate,
            category: category,
            tag: tag,
            status: status,
            date: .current,
            spend: transactions.map { $0.amount }.reduce(.zero, +),
            budget: budgets.map { $0.amount }.reduce(.zero, +),
            categories: categoriesAdapted,
            transactions: transactionsAdapted,
            amount: transactionsAdapted.count
        )
    }
    
    public func getCategories() -> [String] {
        categoryRepository.getAllCategories().map { $0.name } +
        [String.localizable(by: .transactionsCategorieAllSelected)]
    }
    
    public func getTags() -> [String] {
        tagRepository.getTags().map { $0.name } +
        [String.localizable(by: .transactionsCategorieAllSelected)]
    }
}
