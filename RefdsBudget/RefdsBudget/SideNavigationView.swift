import SwiftUI
import RefdsRedux
import RefdsRouter
import RefdsInjection
import Domain
import Data
import Presentation
import UserInterface

struct SideNavigationView: View {
    @Environment(\.isPro) private var isPro
    @EnvironmentObject private var store: RefdsReduxStore<ApplicationStateProtocol>
    @State private var splitVisibility: NavigationSplitViewVisibility = .all
    @RefdsInjection private var viewFactory: ViewFactoryProtocol
    
    private var bindingState: Binding<RefdsReduxState> {
        Binding { store.state } set: {
            guard let state = $0 as? ApplicationStateProtocol else { return }
            store.state = state
        }
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: bindingSplitVisibility) {
            List(NavigationItem.allCases, selection: $store.state.navigationItem) { item in
                NavigationLink(value: item) {
                    Label(item.title, systemImage: item.icon(isPro: isPro).rawValue)
                }
            }
            .listStyle(.sidebar)
        } detail: {
            switch store.state.navigationItem {
            case .profile: profileView
            case .categories: categoriesView
            case .home: homeView
            case .transactions: transactionsView
            case .settings: settingsView
            default: EmptyView()
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    private var profileView: some View {
        RefdsRoutingReduxView(
            router: $store.state.profileRouter,
            state: bindingState,
            action: store.dispatch(action:)
        ) {
            EmptyView()
        }
    }
    
    private var categoriesView: some View {
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
    }
    
    private var homeView: some View {
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
    }
    
    private var transactionsView: some View {
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
    }
    
    private var settingsView: some View {
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
    }
    
    private var bindingSplitVisibility: Binding<NavigationSplitViewVisibility> {
        Binding {
            #if os(macOS)
            splitVisibility
            #else
            .doubleColumn
            #endif
        } set: {
            #if os(macOS)
            splitVisibility = $0
            #endif
        }
    }
}

#Preview {
    SideNavigationView()
}
