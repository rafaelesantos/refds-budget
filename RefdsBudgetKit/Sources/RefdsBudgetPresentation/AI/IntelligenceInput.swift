import CreateML
import CoreML
import TabularData
import RefdsBudgetDomain
import RefdsInjection

public final class IntelligenceInput: MLFeatureProvider {
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
    
    static var budgetEntities: [BudgetModel] {
        budgetRepository.getAllBudgets().map {
            BudgetModel(
                amount: $0.amount,
                category: $0.category,
                date: $0.date,
                id: $0.id,
                message: $0.message
            )
        }
    }
    
    static var categoryEntities: [CategoryModel] {
        categoryRepository.getAllCategories().map {
            CategoryModel(
                budgets: $0.budgets,
                color: $0.color,
                id: $0.id,
                name: $0.name,
                icon: $0.icon
            )
        }
    }
    
    static var transactionEntities: [TransactionModel] {
        transactionRepository.getAllTransactions().map {
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
