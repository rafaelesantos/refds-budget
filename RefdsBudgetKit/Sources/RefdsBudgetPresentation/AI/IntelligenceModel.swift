import Foundation
import RefdsBudgetDomain
import RefdsShared
import CreateML
import CoreML
import TabularData

public enum IntelligenceModel: String, CaseIterable {
    case budgetFromBudgets
    case budgetFromTransactions
    case categoryFromTransactions
    case transactionsFromTags
    
    func getData(
        tagEntities: [TagModelProtocol],
        budgetEntities: [BudgetModelProtocol],
        categoryEntities: [CategoryModelProtocol],
        transactionEntities: [TransactionModelProtocol],
        on step: @escaping (String) -> Void
    ) -> Data? {
        switch self {
        case .budgetFromBudgets: return BudgetFromBudgetsData(
            categoryEntities: categoryEntities,
            budgetEntities: budgetEntities,
            on: step
        )
        case .budgetFromTransactions: return BudgetFromTransactionsData(
            categoryEntities: categoryEntities,
            transactionEntities: transactionEntities,
            on: step
        )
        case .categoryFromTransactions: return CategoryFromTransactionData(
            categoryEntities: categoryEntities,
            transactionEntities: transactionEntities,
            on: step
        )
        case .transactionsFromTags: return TransactionsFromTagsData(
            tagEntities: tagEntities,
            transactionEntities: transactionEntities,
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
