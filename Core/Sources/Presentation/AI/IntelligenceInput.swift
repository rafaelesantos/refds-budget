#if canImport(CreateML)
import CreateML
#endif
import CoreML
import TabularData
import Domain
import RefdsInjection

public final class IntelligenceInput: MLFeatureProvider {
    @RefdsInjection static private var tagRepository: TagUseCase
    @RefdsInjection static private var budgetRepository: BudgetUseCase
    @RefdsInjection static private var categoryRepository: CategoryUseCase
    @RefdsInjection static private var transactionRepository: TransactionUseCase
    
    public var targetKey: String { "target" }
    private var data: [String: Any]
    
    init(data: [String: Any]) {
        self.data = data
    }
    
    public var featureNames: Set<String> {
        Set(data.keys + [targetKey])
    }
    
    public func featureValue(for key: String) -> MLFeatureValue? {
        guard let value = data[key] else { return nil }
        switch value {
        case let value as String: return MLFeatureValue(string: value)
        case let value as Double: return MLFeatureValue(double: value)
        default: return nil
        }
    }
    
    static var tagEntities: [TagModelProtocol] {
        tagRepository.getTags()
    }
    
    static var budgetEntities: [BudgetModelProtocol] {
        budgetRepository.getAllBudgets()
    }
    
    static var categoryEntities: [CategoryModelProtocol] {
        categoryRepository.getAllCategories()
    }
    
    static var transactionEntities: [TransactionModelProtocol] {
        transactionRepository.getAllTransactions()
    }
}
