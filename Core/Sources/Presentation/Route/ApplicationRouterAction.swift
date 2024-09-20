import SwiftUI
import RefdsInjection

public protocol ApplicationRouterActionProtocol {
    typealias Action = (RouteScene, RouteView, [RouteViewState]) -> Void
    typealias AssociatedAction = (URL) -> Void
    
    var action: Action? { get set }
    var associatedAction: AssociatedAction? { get set }
    
    func to(
        scene: RouteScene,
        view: RouteView,
        viewStates: [RouteViewState]
    )
    func to(url: URL)
}

public struct ApplicationRouterAction: ApplicationRouterActionProtocol {
    public typealias Action = (RouteScene, RouteView, [RouteViewState]) -> Void
    public typealias AssociatedAction = (URL) -> Void
    
    public var action: Action?
    public var associatedAction: AssociatedAction?
    
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
    static var defaultValue: ApplicationRouterActionProtocol? = nil
}

public extension EnvironmentValues {
    var navigate: ApplicationRouterActionProtocol? {
        get { self[ApplicationRouterKey.self] }
        set { self[ApplicationRouterKey.self] = newValue }
    }
}

public extension View {
    func navigation(perform action: @escaping ApplicationRouterActionProtocol.Action) -> some View {
        RefdsContainer.register(type: ApplicationRouterActionProtocol.self) {
            var routerAction = RefdsContainer.resolveOptional(type: ApplicationRouterActionProtocol.self) ?? ApplicationRouterAction()
            routerAction.action = action
            return routerAction
        }
        let routerAction = RefdsContainer.resolve(type: ApplicationRouterActionProtocol.self)
        return self.environment(\.navigate, routerAction)
    }
    
    func navigation(perform associatedAction: @escaping ApplicationRouterActionProtocol.AssociatedAction) -> some View {
        RefdsContainer.register(type: ApplicationRouterActionProtocol.self) {
            var routerAction = RefdsContainer.resolveOptional(type: ApplicationRouterActionProtocol.self) ?? ApplicationRouterAction()
            routerAction.associatedAction = associatedAction
            return routerAction
        }
        let routerAction = RefdsContainer.resolve(type: ApplicationRouterActionProtocol.self)
        return self.environment(\.navigate, routerAction)
    }
}
