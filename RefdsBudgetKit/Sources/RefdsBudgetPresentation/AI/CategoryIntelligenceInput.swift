import CreateML
import CoreML
import TabularData

class CategoryIntelligenceInput: MLFeatureProvider {
    private var data: [String: Double]
    
    init(data: [String: Double]) {
        self.data = data
    }
    
    public var featureNames: Set<String> = [
        "month",
        "day",
        "hour",
        "minute",
        "amount",
        "target"
    ]

    public func featureValue(for key: String) -> MLFeatureValue? {
        guard let value = data[key] else { return nil }
        return MLFeatureValue(double: value)
    }
}
