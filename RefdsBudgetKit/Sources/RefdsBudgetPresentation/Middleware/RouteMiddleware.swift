import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class RouteMiddleware<State>: RefdsReduxMiddlewareProtocol {
    #if os(iOS)
    private var horizontalSizeClass: UIUserInterfaceSizeClass {
        UITraitCollection.current.horizontalSizeClass
    }
    #endif
    
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
        case let action as CategoryAction:
            self.handler(for: action, on: completion)
        case let action as AddTransactionAction:
            self.handler(for: action, on: completion)
        case let action as TransactionsAction:
            self.handler(for: action, on: completion)
        case let action as HomeAction:
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
            #if os(iOS)
            switch horizontalSizeClass {
            case .regular:
                switch state.itemNavigation {
                case .premium:
                    state.premiumRouter.popToRoot()
                    state.premiumRouter.route(to: route)
                case .categories:
                    state.categoriesRouter.popToRoot()
                    state.categoriesRouter.route(to: route)
                case .home: 
                    state.homeRouter.popToRoot()
                    state.homeRouter.route(to: route)
                case .transactions:
                    state.transactionsRouter.popToRoot()
                    state.transactionsRouter.route(to: route)
                case .settings:
                    state.settingsRouter.popToRoot()
                    state.settingsRouter.route(to: route)
                case nil: break
                }
                
            default:
                switch state.itemNavigation {
                case .premium:
                    state.premiumRouter.route(to: route)
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
            }
            #else
            switch state.itemNavigation {
            case .premium:
                state.premiumRouter.popToRoot()
                state.premiumRouter.route(to: route)
            case .categories:
                state.categoriesRouter.popToRoot()
                state.categoriesRouter.route(to: route)
            case .home:
                state.homeRouter.popToRoot()
                state.homeRouter.route(to: route)
            case .transactions:
                state.transactionsRouter.popToRoot()
                state.transactionsRouter.route(to: route)
            case .settings:
                state.settingsRouter.popToRoot()
                state.settingsRouter.route(to: route)
            case nil: break
            }
            #endif
        case .dismiss:
            switch state.itemNavigation {
            case .premium:
                state.premiumRouter.dismiss()
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
        case .showCategory: completion(.updateRoute(.category))
        default: break
        }
    }
    
    private func handler(
        for action: CategoryAction,
        on completion: @escaping (ApplicationAction) -> Void
    ) {
        switch action {
        case .editBudget: completion(.updateRoute(.addBudget))
        case .editCategory: completion(.updateRoute(.addCategory))
        case .addTransaction: completion(.updateRoute(.addTransaction))
        case .dismiss: completion(.dismiss)
        default: break
        }
    }
    
    private func handler(
        for action: AddTransactionAction,
        on completion: @escaping (ApplicationAction) -> Void
    ) {
        switch action {
        case .addBudget: completion(.updateRoute(.addBudget))
        case .addCategory: completion(.updateRoute(.addCategory))
        case .dismiss: completion(.dismiss)
        default: break
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
        for action: HomeAction,
        on completion: @escaping (ApplicationAction) -> Void
    ) {
        switch action {
        case .manageTags: completion(.updateRoute(.manageTags))
        case .showSettings: completion(.updateRoute(.settings))
        default: break
        }
    }
}
