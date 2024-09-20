import SwiftUI
import RefdsRedux
import RefdsRouter
import RefdsInjection
import Domain
import Data
import Presentation
import UserInterface

struct TabNavigationView: View {
    @Environment(\.isPro) private var isPro
    @EnvironmentObject var store: RefdsReduxStore<ApplicationStateProtocol>
    @RefdsInjection private var viewFactory: ViewFactoryProtocol
    
    private var bindingState: Binding<RefdsReduxState> {
        Binding { store.state } set: {
            guard let state = $0 as? ApplicationStateProtocol else { return }
            withAnimation { store.state = state }
        }
    }
    
    private var bindingItemNavigation: Binding<Int> {
        Binding {
            store.state.navigationItem?.rawValue ?? .zero
        } set: { rawValue in
            withAnimation {
                if store.state.navigationItem?.rawValue == rawValue,
                   let item = NavigationItem(rawValue: rawValue) {
                    switch item {
                    case .profile: store.state.profileRouter.popToRoot()
                    case .categories: store.state.categoriesRouter.popToRoot()
                    case .home: store.state.homeRouter.popToRoot()
                    case .transactions: store.state.transactionsRouter.popToRoot()
                    case .settings: store.state.settingsRouter.popToRoot()
                    }
                }
                
                store.state.navigationItem = NavigationItem(rawValue: rawValue)
            }
        }
    }
    
    var body: some View {
        TabView(selection: bindingItemNavigation) {
            profileItemView
            categoriesItemView
            homeItemView
            transactionsItemView
            settingsItemView
        }
        .onOpenURL {
            ApplicationRouter(state: $store.state).navigate(url: $0)
        }
        .navigation { scene, view, viewStates in
            ApplicationRouter(state: $store.state).navigate(
                scene: scene,
                view: view,
                viewStates: viewStates
            )
        }
        .navigation { url in
            ApplicationRouter(state: $store.state).navigate(url: url)
        }
    }
    
    private var profileItemView: some View {
        RefdsRoutingReduxView(
            router: $store.state.profileRouter,
            state: bindingState,
            action: store.dispatch(action:)
        ) {
            EmptyView()
        }
        .tabItem {
            Label(
                NavigationItem.profile.title,
                systemImage: NavigationItem.profile.icon(isPro: isPro).rawValue
            )
        }
        .tag(NavigationItem.profile.rawValue)
    }
    
    private var categoriesItemView: some View {
        RefdsRoutingReduxView(
            router: $store.state.categoriesRouter,
            state: bindingState,
            action: store.dispatch(action:)
        ) {
            AnyView(
                viewFactory.makeCategoriesView(
                    state: $store.state.categoriesState,
                    action: store.dispatch(action:)
                )
            )
        }
        .tabItem {
            Label(
                NavigationItem.categories.title,
                systemImage: NavigationItem.categories.icon(isPro: isPro).rawValue
            )
        }
        .tag(NavigationItem.categories.rawValue)
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
                NavigationItem.home.title,
                systemImage: NavigationItem.home.icon(isPro: isPro).rawValue
            )
        }
        .tag(NavigationItem.home.rawValue)
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
                NavigationItem.transactions.title,
                systemImage: NavigationItem.transactions.icon(isPro: isPro).rawValue
            )
        }
        .tag(NavigationItem.transactions.rawValue)
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
                NavigationItem.settings.title,
                systemImage: NavigationItem.settings.icon(isPro: isPro).rawValue
            )
        }
        .tag(NavigationItem.settings.rawValue)
    }
}

#Preview {
    TabNavigationView()
}
