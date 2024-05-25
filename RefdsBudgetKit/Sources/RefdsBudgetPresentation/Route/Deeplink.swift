import Foundation
import SwiftUI
import RefdsRouter

public final class Deeplink {
    public static let shared = Deeplink()
    public static let scheme = "refdsbudget"
    
    public init() {}
    
    public static func url(
        host: Deeplink.Host,
        path: Deeplink.Path = .none
    ) -> URL? {
        URL(string: "\(Deeplink.scheme)://\(host.rawValue)\(path.rawValue)")
    }
    
    public func trigger(
        state: Binding<ApplicationStateProtocol>,
        itemNavigation: Binding<Int>,
        url: URL
    ) {
        guard let (route, item) = parse(url: url) else {
            if let model = FileFactory.shared.fetchData(from: url),
               let item = ItemNavigation(rawValue: itemNavigation.wrappedValue) {
                state.wrappedValue.importState = ImportState(url: url, model: model)
                return navigate(to: .import, with: item, on: state)
            } else { return }
        }
        itemNavigation.wrappedValue = item.rawValue
        guard let route = route else { return }
        navigate(to: route, with: item, on: state)
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
    
    private func navigate(
        to route: ApplicationRoute,
        with item: ItemNavigation,
        on state: Binding<ApplicationStateProtocol>
    ) {
        withAnimation {
            switch item {
            case .premium:
                state.wrappedValue.premiumRouter.route(to: route)
            case .categories:
                state.wrappedValue.categoriesRouter.route(to: route)
            case .home:
                state.wrappedValue.homeRouter.route(to: route)
            case .transactions:
                switch route {
                case .addTransaction:
                    state.wrappedValue.addTransactionState = AddTransactionState()
                    state.wrappedValue.transactionsRouter.route(to: route)
                case .import:
                    state.wrappedValue.transactionsRouter.route(to: route)
                default:
                    break
                }
            case .settings:
                state.wrappedValue.settingsRouter.route(to: route)
            }
        }
    }
}

public extension Deeplink {
    enum Host: String {
        case openPremium = "open-premium"
        case openCategories = "open-categories"
        case openHome = "open-home"
        case openTransactions = "open-transactions"
        case openSettings = "open-settings"
        
        public var itemNavigation: ItemNavigation {
            switch self {
            case .openPremium: return .premium
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
