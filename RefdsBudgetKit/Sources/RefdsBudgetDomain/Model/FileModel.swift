import Foundation
import RefdsShared

public protocol FileModelProtocol {
    var budgets: [BudgetModelProtocol] { get set }
    var categories: [CategoryModelProtocol] { get set }
    var transactions: [TransactionModelProtocol] { get set }
    var url: URL? { get }
}

public struct FileModel: FileModelProtocol, RefdsModel {
    public var budgets: [BudgetModelProtocol]
    public var categories: [CategoryModelProtocol]
    public var transactions: [TransactionModelProtocol]
    
    private enum CodingKeys: String, CodingKey {
        case budgets
        case categories
        case transactions
    }
    
    public init(
        budgets: [BudgetModelProtocol],
        categories: [CategoryModelProtocol],
        transactions: [TransactionModelProtocol]
    ) {
        self.budgets = budgets
        self.categories = categories
        self.transactions = transactions
    }
    
    public var url: URL? {
        let date = Date.current.asString(withDateFormat: .custom("EEEE dd, MMMM yyyy")).capitalized
        let filename: String = .localizable(by: .settingsFilename, with: date)
        guard let encoded = try? JSONEncoder().encode(self),
              let documents = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
        else { return nil }
        
        if !FileManager.default.fileExists(atPath: documents.path, isDirectory: nil) {
            do {
                try FileManager.default.createDirectory(
                    at: documents,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            } catch { print(error.localizedDescription) }
        }
        
        let path = documents.appendingPathComponent("\(filename).budget")
        do {
            try encoded.write(to: path, options: .atomicWrite)
            return path
        } catch { return nil }
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        budgets = try values.decode([BudgetModel].self, forKey: .budgets)
        categories = try values.decode([CategoryModel].self, forKey: .categories)
        transactions = try values.decode([TransactionModel].self, forKey: .transactions)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(budgets.compactMap { $0 as? BudgetModel }, forKey: .budgets)
        try container.encode(categories.compactMap { $0 as? CategoryModel }, forKey: .categories)
        try container.encode(transactions.compactMap { $0 as? TransactionModel }, forKey: .transactions)
    }
}
