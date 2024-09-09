import Foundation
import RefdsBudgetDomain
import RefdsShared
import CreateML
import CoreML
import TabularData

public enum IntelligenceModel: CaseIterable {
    case budgetFromBudgets(Date?)
    case budgetFromTransactions(Date?)
    case categoryFromTransactions
    case transactionsFromTags(Date?)
    case transactionsFromCategories(Date?)
    
    public var rawValue: String {
        switch self {
        case .budgetFromBudgets: return "budgetFromBudgets"
        case .budgetFromTransactions: return "budgetFromTransactions"
        case .categoryFromTransactions: return "categoryFromTransactions"
        case .transactionsFromTags: return "transactionsFromTags"
        case .transactionsFromCategories: return "transactionsFromCategories"
        }
    }
    
    public static var allCases: [IntelligenceModel] {
        [
            .budgetFromBudgets(nil),
            .budgetFromTransactions(nil),
            .categoryFromTransactions,
            .transactionsFromTags(nil),
            .transactionsFromCategories(nil)
        ]
    }
    
    public static func allCases(for date: Date?) -> [IntelligenceModel] {
        [
            .budgetFromBudgets(date),
            .budgetFromTransactions(date),
            .categoryFromTransactions,
            .transactionsFromTags(date),
            .transactionsFromCategories(date)
        ]
    }
    
    func getData(
        tagEntities: [TagModelProtocol],
        budgetEntities: [BudgetModelProtocol],
        categoryEntities: [CategoryModelProtocol],
        transactionEntities: [TransactionModelProtocol],
        on step: @escaping (String) -> Void
    ) -> Data? {
        switch self {
        case let .budgetFromBudgets(excludeDate): return BudgetFromBudgetsData(
            categoryEntities: categoryEntities,
            budgetEntities: budgetEntities,
            excludedDate: excludeDate,
            on: step
        )
        case let .budgetFromTransactions(excludeDate): return BudgetFromTransactionsData(
            categoryEntities: categoryEntities,
            transactionEntities: transactionEntities,
            excludedDate: excludeDate,
            on: step
        )
        case .categoryFromTransactions: return CategoryFromTransactionData(
            categoryEntities: categoryEntities,
            transactionEntities: transactionEntities,
            on: step
        )
        case let .transactionsFromTags(excludeDate): return TransactionsFromTagsData(
            tagEntities: tagEntities,
            transactionEntities: transactionEntities,
            excludedDate: excludeDate,
            on: step
        )
        case let .transactionsFromCategories(excludeDate): return TransactionsFromCategoriesData(
            categories: categoryEntities,
            transactionEntities: transactionEntities,
            excludedDate: excludeDate,
            on: step
        )
        }
    }
    
    func key(for level: IntelligenceLevel) -> String {
        "\(rawValue)-\(level.rawValue)"
    }
    
    private func file(for level: IntelligenceLevel) -> String {
        "\(key(for: level)).mlmodel"
    }
    
    func model(for level: IntelligenceLevel) -> MLModel? {
        guard let _ = RefdsDefaults<Data>.get(for: key(for: level)),
              let url = RefdsFileManager.default.path(with: file(for: level), privacy: .private),
              let urlModel = try? MLModel.compileModel(at: url),
              let model = try? MLModel(contentsOf: urlModel)
        else { return nil }
        return model
    }
    
    func delete(for level: IntelligenceLevel) {
        RefdsDefaults.set(Data(), for: key(for: level))
    }
    
    func save(
        _ regressor: MLBoostedTreeRegressor,
        for level: IntelligenceLevel
    ) {
        guard let path = RefdsFileManager.default.path(
            with: file(for: level),
            privacy: .private
        ) else { return }
        
        do {
            try regressor.write(to: path)
            guard let data = path.asData else { return }
            RefdsDefaults.set(data, for: key(for: level))
        } catch { return }
    }
}
