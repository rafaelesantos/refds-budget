import Foundation
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetResource

public final class FileFactory {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    
    public static let shared = FileFactory()
    
    private init() {}
    
    public func getTransactionsText(for ids: Set<UUID>) -> String {
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
        return transactions
    }
    
    public func getFileURL(
        budgetsId: Set<UUID> = [],
        categoriesId: Set<UUID> = [],
        transactionsId: Set<UUID> = []
    ) -> URL {
        let transactions = getTransactions(for: transactionsId)
        let categoriesId = transactionsId.isEmpty ? categoriesId : categoriesId.union(Set(transactions.map { $0.category }))
        let dates = transactions.map { $0.date.asString(withDateFormat: .monthYear) }
        let categories = getCategories(for: categoriesId)
        let budgets = getBudgets(
            for: budgetsId,
            categoriesId: categoriesId,
            dates: dates
        )
        
        return FileModel(
            budgets: budgets,
            categories: categories,
            transactions: transactions
        ).url ?? .budget(for: .appleStoreReference)
    }
    
    public func fetchData(from url: URL) -> FileModel? {
        let _ = url.startAccessingSecurityScopedResource()
        guard let data = try? Data(contentsOf: url),
              let file: FileModel = data.asModel() else { 
            defer { url.stopAccessingSecurityScopedResource() }
            return nil
        }
        defer { url.stopAccessingSecurityScopedResource() }
        return file
    }
    
    public func importData(from file: FileModel, on url: URL) throws {
        var categories: [CategoryEntity] = []
        file.categories.forEach {
            let category = categoryRepository.getCategory(by: $0.id) ?? CategoryEntity(context: database.viewContext)
            category.id = $0.id
            category.name = $0.name.capitalized
            category.color = $0.color
            category.budgets = $0.budgets
            category.icon = $0.icon
            categories += [category]
        }
        
        var budgets: [BudgetEntity] = []
        file.budgets.forEach {
            let budget = categoryRepository.getBudget(by: $0.id) ?? BudgetEntity(context: database.viewContext)
            budget.id = $0.id
            budget.amount = $0.amount
            budget.date = $0.date
            budget.message = $0.message
            budget.category = $0.category
            budgets += [budget]
        }
        
        var transactions: [TransactionEntity] = []
        file.transactions.forEach {
            let transaction = transactionRepository.getTransaction(by: $0.id) ?? TransactionEntity(context: database.viewContext)
            transaction.id = $0.id
            transaction.date = $0.date
            transaction.message = $0.message
            transaction.category = $0.category
            transaction.amount = $0.amount
            transaction.status = $0.status
            transactions += [transaction]
        }
        
        try database.viewContext.save()

    }
    
    private func getBudgets(for ids: Set<UUID>, categoriesId: Set<UUID>, dates: [String]) -> [BudgetModel] {
        let budgetsEntity = categoryRepository.getAllBudgets().filter {
            (ids.isEmpty ? true : ids.contains($0.id)) &&
            (categoriesId.isEmpty ? true : categoriesId.contains($0.category)) &&
            (dates.isEmpty ? true : dates.contains($0.date.asString(withDateFormat: .monthYear)))
        }
        
        return budgetsEntity.map {
            BudgetModel(
                amount: $0.amount,
                category: $0.category,
                date: $0.date,
                id: $0.id,
                message: $0.message
            )
        }
    }
    
    private func getCategories(for ids: Set<UUID>) -> [CategoryModel] {
        let categoriesEntity = categoryRepository.getAllCategories().filter {
            ids.isEmpty ? true : ids.contains($0.id)
        }
        
        return categoriesEntity.map {
            CategoryModel(
                budgets: $0.budgets,
                color: $0.color,
                id: $0.id,
                name: $0.name,
                icon: $0.icon
            )
        }
    }
    
    private func getTransactions(for ids: Set<UUID>) -> [TransactionModel] {
        let transactionsEntity = transactionRepository.getTransactions().filter {
            ids.isEmpty ? true : ids.contains($0.id)
        }
        
        return transactionsEntity.map {
            TransactionModel(
                amount: $0.amount,
                category: $0.category,
                date: $0.date,
                id: $0.id,
                message: $0.message,
                status: $0.status
            )
        }
    }
}
