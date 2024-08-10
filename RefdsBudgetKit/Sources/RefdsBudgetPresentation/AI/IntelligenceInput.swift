import CreateML
import CoreML
import TabularData
import RefdsBudgetDomain
import RefdsInjection

public final class IntelligenceInput: MLFeatureProvider {
    @RefdsInjection static private var tagRepository: TagUseCase
    @RefdsInjection static private var budgetRepository: BudgetUseCase
    @RefdsInjection static private var categoryRepository: CategoryUseCase
    @RefdsInjection static private var transactionRepository: TransactionUseCase
    
    public var targetKey: String { "target" }
    private var data: [String: Double]
    
    init(data: [String: Double]) {
        self.data = data
    }
    
    public var featureNames: Set<String> {
        Set(data.keys + [targetKey])
    }
    
    public func featureValue(for key: String) -> MLFeatureValue? {
        guard let value = data[key] else { return nil }
        return MLFeatureValue(double: value)
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
