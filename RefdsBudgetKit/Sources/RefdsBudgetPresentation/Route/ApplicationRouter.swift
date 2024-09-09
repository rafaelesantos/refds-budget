import SwiftUI
import RefdsNetwork

public final class ApplicationRouter {
    @Binding private var state: ApplicationStateProtocol
    private static let scheme = "refdsbudget"
    
    public init(state: Binding<ApplicationStateProtocol>) {
        self._state = state
    }
    
    public static func deeplinkURL(
        scene: RouteScene,
        view: RouteView,
        viewStates: [RouteViewState]
    ) -> URL? {
        URL(string: "\(scheme)://\(scene.rawValue)\(view.rawValue)\(viewStates.rawValue)")
    }
    
    public func navigate(
        scene: RouteScene,
        view: RouteView,
        viewStates: [RouteViewState]
    ) {
        withAnimation {
            state.itemNavigation = scene.itemNavigation ?? state.itemNavigation
            state = updatedState(
                with: scene.itemNavigation ?? state.itemNavigation,
                and: view.route,
                for: viewStates
            )
            navigate(
                with: scene.itemNavigation ?? state.itemNavigation,
                and: view.route,
                isDismiss: view == .dismiss
            )
        }
    }
    
    public func navigate(url: URL) {
        guard let (scene, view, viewStates) = parse(url: url) else {
            return navigateImport(from: url)
        }
        withAnimation {
            state.itemNavigation = scene.itemNavigation ?? state.itemNavigation
            state = updatedState(
                with: scene.itemNavigation ?? state.itemNavigation,
                and: view.route,
                for: viewStates
            )
            navigate(
                with: scene.itemNavigation ?? state.itemNavigation,
                and: view.route,
                isDismiss: view == .dismiss
            )
        }
    }
    
    private func navigateImport(from url: URL) {
        if let model = FileFactory.shared.fetchData(from: url) {
            state.importState = ImportState(url: url, model: model)
            withAnimation {
                navigate(
                    with: state.itemNavigation ?? .home,
                    and: .import,
                    isDismiss: false
                )
            }
        }
    }
    
    private func navigate(
        with item: ItemNavigation?,
        and route: ApplicationRoute?,
        isDismiss: Bool
    ) {
        guard let route = route else { return }
        switch item {
        case .premium:
            guard !isDismiss else { return state.premiumRouter.dismiss() }
            state.premiumRouter.route(to: route)
        case .categories:
            guard !isDismiss else { return state.categoriesRouter.dismiss() }
            state.categoriesRouter.route(to: route)
        case .home:
            guard !isDismiss else { return state.homeRouter.dismiss() }
            state.homeRouter.route(to: route)
        case .transactions:
            guard !isDismiss else { return state.transactionsRouter.dismiss() }
            state.transactionsRouter.route(to: route)
        case .settings:
            guard !isDismiss else { return state.settingsRouter.dismiss() }
            state.settingsRouter.route(to: route)
        case .none:
            break
        }
    }
    
    private func updatedState(
        with item: ItemNavigation?,
        and route: ApplicationRoute?,
        for viewState: [RouteViewState]
    ) -> ApplicationStateProtocol {
        var newState = state
        
        switch route {
        case .addBudget:
            newState.addBudgetState = AddBudgetState()
        case .addCategory:
            newState.addCategoryState = AddCategoryState()
        case .addTransaction:
            newState.addTransactionState = AddTransactionState()
        default:
            break
        }
        
        viewState.forEach { viewState in
            if route == .none {
                switch item {
                case .categories:
                    switch viewState {
                    case .date(let date): newState.categoriesState.filter.date = date
                    case .isDateFilter(let isDateFilter): newState.categoriesState.filter.isDateFilter = isDateFilter
                    default: break
                    }
                case .home:
                    switch viewState {
                    case .date(let date): newState.homeState.filter.date = date
                    case .isDateFilter(let isDateFilter): newState.homeState.filter.isDateFilter = isDateFilter
                    case .selectedItems(let items): newState.homeState.filter.selectedItems = items
                    default: break
                    }
                case .transactions:
                    switch viewState {
                    case .date(let date): newState.transactionsState.filter.date = date
                    case .isDateFilter(let isDateFilter): newState.transactionsState.filter.isDateFilter = isDateFilter
                    case .selectedItems(let items): newState.transactionsState.filter.selectedItems = items
                    default: break
                    }
                case .premium, .settings, .none:
                    break
                }
            } else {
                switch route {
                case .addBudget:
                    switch viewState {
                    case .id(let id): newState.addBudgetState.id = id
                    case .date(let date): newState.addBudgetState.date = date
                    case .selectedItems(let items): newState.addBudgetState.categoryName = items.first
                    default: break
                    }
                case .addCategory:
                    switch viewState {
                    case .id(let id): newState.addCategoryState.id = id
                    default: break
                    }
                case .category:
                    switch viewState {
                    case .id(let id): newState.categoryState.id = id
                    default: break
                    }
                case .addTransaction:
                    switch viewState {
                    case .id(let id): newState.addTransactionState.id = id
                    case .date(let date): newState.addTransactionState.date = date
                    default: break
                    }
                case .budgetSelection:
                    switch viewState {
                    case .hasAI(let hasAI):
                        newState.budgetSelectionState.hasAI = hasAI
                    default: break
                    }
                case .budgetComparison:
                    switch viewState {
                    case .baseBudgetDate(let date):
                        newState.budgetComparisonState.baseBudgetDate = date
                    case .compareBudgetDate(let date):
                        newState.budgetComparisonState.compareBudgetDate = date
                    case .hasAI(let hasAI):
                        newState.budgetComparisonState.hasAI = hasAI
                    default: break
                    }
                default:
                    break
                }
            }
        }
        
        return newState
    }
    
    private func parse(url: URL) -> (RouteScene, RouteView, [RouteViewState])? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              url.scheme == Self.scheme || url.scheme == RefdsHttpScheme.https.rawValue,
              let host = getHost(from: components),
              let scene = parse(host: host),
              let path = getPath(from: components),
              let view = parse(path: path)
        else { return nil }
        let viewStates = parse(query: components.queryItems)
        return (scene, view, viewStates)
    }
    
    private func getHost(from components: URLComponents) -> String? {
        components.url?.scheme == RefdsHttpScheme.https.rawValue ?
        components.path.components(separatedBy: "/")[safe: 1] :
        components.host
    }
    
    private func getPath(from components: URLComponents) -> String? {
        components.url?.scheme == RefdsHttpScheme.https.rawValue ?
        "/" + components.path.components(separatedBy: "/")
            .dropFirst()
            .dropFirst()
            .joined(separator: "/") :
        components.path
    }
    
    private func parse(host: String) -> RouteScene? {
        RouteScene(rawValue: host)
    }
    
    private func parse(path: String) -> RouteView? {
        RouteView(rawValue: path)
    }
    
    private func parse(query: [URLQueryItem]?) -> [RouteViewState] {
        guard let query = query else { return [] }
        return query.compactMap { RouteViewState(queryItem: $0) }
    }
}

public struct ApplicationRouterAction {
    public typealias Action = (RouteScene, RouteView, [RouteViewState]) -> Void
    public typealias AssociatedAction = (URL) -> Void
    
    private let action: Action?
    private let associatedAction: AssociatedAction?
    
    public init(
        action: Action? = nil,
        associatedAction: AssociatedAction? = nil
    ) {
        self.action = action
        self.associatedAction = associatedAction
    }
    
    public func to(
        scene: RouteScene = .current,
        view: RouteView,
        viewStates: [RouteViewState] = []
    ) {
        action?(
            scene,
            view,
            viewStates
        )
    }
    
    public func to(url: URL) {
        associatedAction?(url)
    }
}

private struct ApplicationRouterKey: EnvironmentKey {
    static var defaultValue: ApplicationRouterAction? = nil
}

public extension EnvironmentValues {
    var navigate: ApplicationRouterAction? {
        get { self[ApplicationRouterKey.self] }
        set { self[ApplicationRouterKey.self] = newValue }
    }
}

public extension View {
    func navigation(perform action: @escaping ApplicationRouterAction.Action) -> some View {
        self.environment(\.navigate, ApplicationRouterAction(action: action))
    }
    
    func navigation(perform associatedAction: @escaping ApplicationRouterAction.AssociatedAction) -> some View {
        self.environment(\.navigate, ApplicationRouterAction(associatedAction: associatedAction))
    }
}
