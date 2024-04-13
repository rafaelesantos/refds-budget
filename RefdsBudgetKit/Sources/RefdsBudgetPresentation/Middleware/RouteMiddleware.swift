import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class RouteMiddleware<State>: RefdsReduxMiddlewareProtocol {
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        switch action {
        case let action as ApplicationAction:
            self.handler(with: state as? ApplicationStateProtocol, for: action)
        case let action as AddBudgetAction:
            self.handler(for: action, on: completion)
        case let action as AddCategoryAction:
            self.handler(for: action, on: completion)
        case let action as CategoriesAction:
            self.handler(for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: ApplicationStateProtocol?,
        for action: ApplicationAction
    ) {
        switch action {
        case let .updateRoute(route):
            state?.router.route(to: route)
        case .dismiss:
            state?.router.dismiss()
        }
    }
    
    private func handler(
        for action: AddBudgetAction,
        on completion: @escaping (ApplicationAction) -> Void
    ) {
        switch action {
        case .dismiss: completion(.dismiss)
        default: break
        }
    }
    
    private func handler(
        for action: AddCategoryAction,
        on completion: @escaping (ApplicationAction) -> Void
    ) {
        switch action {
        case .dismiss: completion(.dismiss)
        default: break
        }
    }
    
    private func handler(
        for action: CategoriesAction,
        on completion: @escaping (ApplicationAction) -> Void
    ) {
        switch action {
        case .addBudget: completion(.updateRoute(.addBudget))
        case .addCategory: completion(.updateRoute(.addCategory))
        default: break
        }
    }
}
