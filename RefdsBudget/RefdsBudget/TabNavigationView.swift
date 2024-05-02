import SwiftUI
import RefdsRedux
import RefdsRouter
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetPresentation
import RefdsBudgetUI

struct TabNavigationView: View {
    @EnvironmentObject var store: RefdsReduxStore<ApplicationStateProtocol>
    @RefdsInjection private var viewFactory: ViewFactoryProtocol
    
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
                case .categories: store.state.categoriesRouter.popToRoot()
                case .home: store.state.homeRouter.popToRoot()
                case .transactions: store.state.transactionsRouter.popToRoot()
                case .settings: break
                }
            }
            store.state.itemNavigation = ItemNavigation(rawValue: $0)
        }
    }
    
    var body: some View {
        TabView(selection: bindingItemNavigation) {
            categoriesItemView
            homeItemView
            transactionsItemView
        }
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
                systemImage: ItemNavigation.categories.icon.rawValue
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
                systemImage: ItemNavigation.home.icon.rawValue
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
                systemImage: ItemNavigation.transactions.icon.rawValue
            )
        }
        .tag(ItemNavigation.transactions.rawValue)
    }
}

#Preview {
    TabNavigationView()
}
