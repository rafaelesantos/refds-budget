import Foundation
import WidgetKit
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetResource

public final class FileFactory {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    @RefdsInjection private var budgetRepository: BudgetUseCase
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
        
        let ids = ids.map {
            let date = transactionRepository.getTransaction(by: $0)?.date.date ?? .current
            return ($0, date)
        }.sorted(by: { $0.1.timeIntervalSince1970 < $1.1.timeIntervalSince1970 })
    
        ids.forEach { id, _ in
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
    
    public func importData(from file: FileModelProtocol, on url: URL) throws {
        try database.viewContext.performAndWait {
            var categories: [CategoryEntity] = []
            var budgets: [BudgetEntity] = []
            var transactions: [TransactionEntity] = []
            
            file.categories.forEach {
                categories += [$0.getEntity(for: self.database.viewContext)]
            }
            
            file.budgets.forEach {
                budgets += [$0.getEntity(for: self.database.viewContext)]
            }
            
            file.transactions.forEach {
                transactions += [$0.getEntity(for: self.database.viewContext)]
            }
            
            try self.database.viewContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    private func getBudgets(
        for ids: Set<UUID>,
        categoriesId: Set<UUID>,
        dates: [String]
    ) -> [BudgetModelProtocol] {
        budgetRepository.getAllBudgets().filter {
            (ids.isEmpty ? true : ids.contains($0.id)) &&
            (categoriesId.isEmpty ? true : categoriesId.contains($0.category)) &&
            (dates.isEmpty ? true : dates.contains($0.date.asString(withDateFormat: .monthYear)))
        }
    }
    
    private func getCategories(for ids: Set<UUID>) -> [CategoryModelProtocol] {
        categoryRepository.getAllCategories().filter {
            ids.isEmpty ? true : ids.contains($0.id)
        }
    }
    
    private func getTransactions(for ids: Set<UUID>) -> [TransactionModelProtocol] {
        transactionRepository.getAllTransactions().filter {
            ids.isEmpty ? true : ids.contains($0.id)
        }
    }
}
