import CreateML
import CoreML
import TabularData

class BudgetIntelligenceInput: MLFeatureProvider {
    private var data: [String: Double]
    
    init(data: [String: Double]) {
        self.data = data
    }
    
    public var featureNames: Set<String> = [
        "year",
        "month",
        "category",
        "transactions"
    ]

    public func featureValue(for key: String) -> MLFeatureValue? {
        guard let value = data[key] else { return nil }
        return MLFeatureValue(double: value)
    }
}
