import Foundation
#if canImport(CreateML)
import CreateML
#endif

public enum IntelligenceLevel: String, CaseIterable {
    case low
    case medium
    case high
    case ultra
    case custom
    
    #if canImport(CreateML)
    var params: MLBoostedTreeRegressor.ModelParameters {
        MLBoostedTreeRegressor.ModelParameters(
            validation: .none,
            maxDepth: maxDepth,
            maxIterations: maxIterations
        )
    }
    #endif
    
    private var maxDepth: Int {
        switch self {
        case .low: return 50
        case .medium: return 250
        case .high: return 500
        case .ultra, .custom: return 1_000
        }
    }
    
    private var maxIterations: Int {
        switch self {
        case .low: return 10
        case .medium: return 100
        case .high: return 500
        case .ultra, .custom: return 1_000
        }
    }
}
