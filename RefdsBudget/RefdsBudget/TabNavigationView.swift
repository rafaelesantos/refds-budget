import SwiftUI
import RefdsRedux
import RefdsRouter
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetPresentation
import RefdsBudgetUI

struct TabNavigationView: View {
    @Environment(\.isPro) private var isPro
    @EnvironmentObject var store: RefdsReduxStore<ApplicationStateProtocol>
    @RefdsInjection private var viewFactory: ViewFactoryProtocol
    private var deeplink: Deeplink = .shared
    
    private var bindingState: Binding<RefdsReduxState> {
        Binding { store.state } set: {
            guard let state = $0 as? ApplicationStateProtocol else { return }
            store.state = state
        }
    }
    
    private var bindingItemNavigation: Binding<Int> {
        Binding {
            store.state.itemNavigation?.rawValue ?? .zero
        } set: {
            if store.state.itemNavigation?.rawValue == $0, let item = ItemNavigation(rawValue: $0) {
                switch item {
                case .premium: store.state.premiumRouter.popToRoot()
                case .categories: store.state.categoriesRouter.popToRoot()
                case .home: store.state.homeRouter.popToRoot()
                case .transactions: store.state.transactionsRouter.popToRoot()
                case .settings: store.state.settingsRouter.popToRoot()
                }
            }
            store.state.itemNavigation = ItemNavigation(rawValue: $0)
        }
    }
    
    var body: some View {
        TabView(selection: bindingItemNavigation) {
            premiumItemView
            categoriesItemView
            homeItemView
            transactionsItemView
            settingsItemView
        }
        .onOpenURL {
            deeplink.trigger(
                state: $store.state,
                itemNavigation: bindingItemNavigation,
                url: $0
            )
        }
    }
    
    private var premiumItemView: some View {
        RefdsRoutingReduxView(
            router: $store.state.premiumRouter,
            state: bindingState,
            action: store.dispatch(action:)
        ) {
            AnyView(
                viewFactory.makeSubscriptionView(
                    state: $store.state.settingsState,
                    action: store.dispatch(action:)
                )
            )
        }
        .tabItem {
            Label(
                ItemNavigation.premium.title,
                systemImage: ItemNavigation.premium.icon(isPro: isPro).rawValue
            )
        }
        .tag(ItemNavigation.premium.rawValue)
    }
    
    private var categoriesItemView: some View {
        RefdsRoutingReduxView(
            router: $store.state.categoriesRouter,
            state: bindingState,
            action: store.dispatch(action:)
        ) {
            AnyView(
                viewFactory.makeCegoriesView(
                    state: $store.state.categoriesState,
                    action: store.dispatch(action:)
                )
            )
        }
        .tabItem {
            Label(
                ItemNavigation.categories.title,
                systemImage: ItemNavigation.categories.icon(isPro: isPro).rawValue
            )
        }
        .tag(ItemNavigation.categories.rawValue)
    }
    
    private var homeItemView: some View {
        RefdsRoutingReduxView(
            router: $store.state.homeRouter,
            state: bindingState,
            action: store.dispatch(action:)
        ) {
            AnyView(
                viewFactory.makeHomeView(
                    state: $store.state.homeState,
                    action: store.dispatch(action:)
                )
            )
        }
        .tabItem {
            Label(
                ItemNavigation.home.title,
                systemImage: ItemNavigation.home.icon(isPro: isPro).rawValue
            )
        }
        .tag(ItemNavigation.home.rawValue)
    }
    
    private var transactionsItemView: some View {
        RefdsRoutingReduxView(
            router: $store.state.transactionsRouter,
            state: bindingState,
            action: store.dispatch(action:)
        ) {
            AnyView(
                viewFactory.makeTransactionsView(
                    state: $store.state.transactionsState,
                    action: store.dispatch(action:)
                )
            )
        }
        .tabItem {
            Label(
                ItemNavigation.transactions.title,
                systemImage: ItemNavigation.transactions.icon(isPro: isPro).rawValue
            )
        }
        .tag(ItemNavigation.transactions.rawValue)
    }
    
    private var settingsItemView: some View {
        RefdsRoutingReduxView(
            router: $store.state.settingsRouter,
            state: bindingState,
            action: store.dispatch(action:)
        ) {
            AnyView(
                viewFactory.makeSettingsView(
                    state: $store.state.settingsState,
                    action: store.dispatch(action:)
                )
            )
        }
        .tabItem {
            Label(
                ItemNavigation.settings.title,
                systemImage: ItemNavigation.settings.icon(isPro: isPro).rawValue
            )
        }
        .tag(ItemNavigation.settings.rawValue)
    }
}

#Preview {
    TabNavigationView()
}
