import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import Domain
import Resource

public final class RouteMiddleware<State>: RefdsReduxMiddlewareProtocol {
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        switch action {
        case let action as ApplicationAction:
            self.handler(with: state as? ApplicationStateProtocol, for: action)
        case let action as TransactionsAction:
            self.handler(for: action, on: completion)
        case let action as ImportAction:
            self.handler(for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: ApplicationStateProtocol?,
        for action: ApplicationAction
    ) {
        guard let state = state else { return }
        switch action {
        case let .updateRoute(route):
            switch state.navigationItem {
            case .profile:
                state.profileRouter.route(to: route)
            case .categories:
                state.categoriesRouter.route(to: route)
            case .home:
                state.homeRouter.route(to: route)
            case .transactions:
                state.transactionsRouter.route(to: route)
            case .settings:
                state.settingsRouter.route(to: route)
            case nil: break
            }
        case .dismiss:
            switch state.navigationItem {
            case .profile:
                state.profileRouter.dismiss()
            case .categories:
                state.categoriesRouter.dismiss()
            case .home:
                state.homeRouter.dismiss()
            case .transactions:
                state.transactionsRouter.dismiss()
            case .settings:
                state.settingsRouter.dismiss()
            case nil: break
            }
        }
    }
    
    private func handler(
        for action: TransactionsAction,
        on completion: @escaping (ApplicationAction) -> Void
    ) {
        switch action {
        case .addTransaction: completion(.updateRoute(.addTransaction))
        default: break
        }
    }
    
    private func handler(
        for action: ImportAction,
        on completion: @escaping (ApplicationAction) -> Void
    ) {
        switch action {
        case .dismiss: completion(.dismiss)
        default: break
        }
    }
}
