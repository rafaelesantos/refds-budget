import Foundation

public enum RouteScene: String {
    case premium = "premium"
    case categories = "categories"
    case home = "home"
    case transactions = "transactions"
    case settings = "settings"
    case current = "current"
    
    public var itemNavigation: ItemNavigation? {
        switch self {
        case .premium: return .premium
        case .categories: return .categories
        case .home: return .home
        case .transactions: return .transactions
        case .settings: return .settings
        case .current: return .none
        }
    }
}
