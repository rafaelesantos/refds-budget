import Foundation
import SwiftUI
import RefdsRouter

public final class Deeplink {
    public static let shared = Deeplink()
    public static let scheme = "refdsbudget"
    
    public init() {}
    
    public static func url(
        host: Deeplink.Host,
        path: Deeplink.Path
    ) -> URL? {
        URL(string: "\(Deeplink.scheme)://\(host.rawValue)\(path.rawValue)")
    }
    
    public func trigger(
        state: Binding<ApplicationStateProtocol>,
        itemNavigation: Binding<Int>,
        url: URL
    ) {
        guard let (route, item) = parse(url: url) else { return }
        withAnimation {
            itemNavigation.wrappedValue = item.rawValue
            guard let route = route else { return }
            switch item {
            case .categories: 
                state.wrappedValue.categoriesRouter.route(to: route)
            case .home:
                state.wrappedValue.homeRouter.route(to: route)
            case .transactions:
                state.wrappedValue.addTransactionState = AddTransactionState()
                state.wrappedValue.transactionsRouter.route(to: route)
            case .settings:
                state.wrappedValue.settingsRouter.route(to: route)
            }
        }
    }
    
    private func parse(url: URL) -> (ApplicationRoute?, ItemNavigation)? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              url.scheme == Deeplink.scheme,
              let hostValue = components.host,
              let host = parse(host: hostValue),
              let path = parse(path: components.path)
        else { return nil }
        return (path.route, host.itemNavigation)
    }
    
    private func parse(host: String) -> Deeplink.Host? {
        Deeplink.Host(rawValue: host)
    }
    
    private func parse(path: String) -> Deeplink.Path? {
        Deeplink.Path(rawValue: path)
    }
}

public extension Deeplink {
    enum Host: String {
        case openCategories = "open-categories"
        case openHome = "open-home"
        case openTransactions = "open-transactions"
        case openSettings = "open-settings"
        
        public var itemNavigation: ItemNavigation {
            switch self {
            case .openCategories: return .categories
            case .openHome: return .home
            case .openTransactions: return .transactions
            case .openSettings: return .settings
            }
        }
    }
    
    enum Path: String {
        case addBudget = "/add-budget"
        case addCategory = "/add-category"
        case addTransaction = "/add-transaction"
        case category = "/category"
        case manageTags = "/manage-tags"
        case none = "/"
        
        public var route: ApplicationRoute? {
            switch self {
            case .addBudget: return .addBudget
            case .addCategory: return .addCategory
            case .addTransaction: return .addTransaction
            case .category: return .category
            case .manageTags: return .manageTags
            case .none: return nil
            }
        }
    }
}
