import Foundation
import RefdsRedux
import RefdsBudgetPresentation

enum EnvironmentConfiguration: String {
    case releaseDevelopment = "Release Development"
    case releaseProduction = "Release Production"
    
    static var current: EnvironmentConfiguration {
        guard let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String,
              let environment = EnvironmentConfiguration(rawValue: currentConfiguration) else { return .releaseProduction }
        return environment
    }
    
    static var store: RefdsReduxStore<any ApplicationStateProtocol> {
        let environment = current
        switch environment {
        case .releaseDevelopment: return RefdsReduxStoreFactory.development
        case .releaseProduction: return RefdsReduxStoreFactory.production
        }
    }
}
