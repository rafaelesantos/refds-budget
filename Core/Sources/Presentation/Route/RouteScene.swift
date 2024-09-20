import Foundation
import Domain

public enum RouteScene: String {
    case profile = "profile"
    case categories = "categories"
    case home = "home"
    case transactions = "transactions"
    case settings = "settings"
    case current = "current"
    
    public var navigationItem: NavigationItem? {
        switch self {
        case .profile: return .profile
        case .categories: return .categories
        case .home: return .home
        case .transactions: return .transactions
        case .settings: return .settings
        case .current: return .none
        }
    }
}
