import SwiftUI
import RefdsRedux
import RefdsRouter
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetPresentation
import RefdsBudgetUI

struct ContentView: View {
    @State private var splitVisibility: NavigationSplitViewVisibility = .all
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @StateObject private var store = RefdsReduxStoreFactory().production
    
    private var viewFactory = ViewFactory()
    
    init() {
        RefdsContainer.register(type: ViewFactoryProtocol.self) { viewFactory }
    }
    
    private var bindingState: Binding<RefdsReduxState> {
        Binding {
            store.state
        } set: {
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
                case .home: break
                case .transactions: store.state.transactionsRouter.popToRoot()
                case .settings: break
                }
            }
            store.state.itemNavigation = ItemNavigation(rawValue: $0)
        }
    }
    
    var body: some View {
        switch horizontalSizeClass {
        case .compact: tabNavigationView
        default: sideNavigationView
        }
    }
    
    private var tabNavigationView: some View {
        TabView(selection: bindingItemNavigation) {
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
            
            RefdsRoutingReduxView(
                router: $store.state.transactionsRouter,
                state: bindingState,
                action: store.dispatch(action:)
            ) {
                AnyView(
                    viewFactory.makeTransactionsView(
                        state: $store.state.transactions,
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
    
    private var sideNavigationView: some View {
        NavigationSplitView(columnVisibility: bindingSplitVisibility) {
            List(ItemNavigation.allCases, selection: $store.state.itemNavigation) { item in
                NavigationLink(value: item) {
                    Label(item.title, systemImage: item.icon.rawValue)
                        .font(.title3)
                }
                .padding(.vertical, 3)
            }
            .listStyle(.sidebar)
            .navigationSplitViewColumnWidth(250)
        } content: {
            switch store.state.itemNavigation {
            case .categories:
                AnyView(
                    viewFactory.makeCegoriesView(
                        state: $store.state.categoriesState,
                        action: store.dispatch(action:)
                    )
                )
                .navigationSplitViewColumnWidth(360)
            case .transactions:
                AnyView(
                    viewFactory.makeTransactionsView(
                        state: $store.state.transactions,
                        action: store.dispatch(action:)
                    )
                )
                .navigationSplitViewColumnWidth(360)
            default: EmptyView()
            }
            
        } detail: {
            switch store.state.itemNavigation {
            case .categories:
                RefdsRoutingReduxView(
                    router: $store.state.categoriesRouter,
                    state: bindingState,
                    action: store.dispatch(action:)
                ) {
                    AnyView(
                        viewFactory.makeCategoryView(
                            state: $store.state.categoryState,
                            action: store.dispatch(action:)
                        )
                    )
                }
                .navigationSplitViewColumnWidth(min: 450, ideal: 450)
            case .transactions:
                RefdsRoutingReduxView(
                    router: $store.state.transactionsRouter,
                    state: bindingState,
                    action: store.dispatch(action:)
                ) {
                    AnyView(
                        viewFactory.makeAddTransactionView(
                            state: $store.state.addTransaction,
                            action: store.dispatch(action:)
                        )
                    )
                }
                .navigationSplitViewColumnWidth(min: 450, ideal: 450)
            default:
                EmptyView()
            }
        }
        .navigationSplitViewStyle(.balanced)
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
    ContentView()
}
