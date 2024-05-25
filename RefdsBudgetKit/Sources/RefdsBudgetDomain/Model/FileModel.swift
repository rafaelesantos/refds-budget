import Foundation
import RefdsShared

public protocol FileModelProtocol: RefdsModel {
    var budgets: [BudgetModel] { get set }
    var categories: [CategoryModel] { get set }
    var transactions: [TransactionModel] { get set }
    var url: URL? { get }
}

public struct FileModel: FileModelProtocol {
    public var budgets: [BudgetModel]
    public var categories: [CategoryModel]
    public var transactions: [TransactionModel]
    
    public init(
        budgets: [BudgetModel],
        categories: [CategoryModel],
        transactions: [TransactionModel]
    ) {
        self.budgets = budgets
        self.categories = categories
        self.transactions = transactions
    }
    
    public var url: URL? {
        let date = Date.current.asString(withDateFormat: .custom("EEEE dd, MMMM yyyy")).capitalized
        let filename: String = .localizable(by: .settingsFilename, with: date)
        guard let encoded = try? JSONEncoder().encode(self),
              let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return nil }
        
        let path = documents.appendingPathComponent("/\(filename).budget")
        do {
            try encoded.write(to: path, options: .atomicWrite)
            return path
        } catch { return nil }
    }
}
