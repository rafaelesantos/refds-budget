import SwiftUI
import RefdsRedux
import RefdsRouter
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetPresentation
import RefdsBudgetUI

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
            List(ItemNavigation.allCases, selection: $store.state.itemNavigation) { item in
                NavigationLink(value: item) {
                    Label(item.title, systemImage: item.icon(isPro: isPro).rawValue)
                }
            }
            .listStyle(.sidebar)
        } content: {
            switch store.state.itemNavigation {
            case .categories: categoriesView
            case .home: homeView
            case .transactions: transactionsView
            case .settings: settingsView
            default: EmptyView()
            }
            
        } detail: {
            switch store.state.itemNavigation {
            case .categories: detailCategoriesView
            case .home: detailTransactionsView
            case .transactions: detailAddTransactionView
            default: EmptyView()
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    private var categoriesView: some View {
        AnyView(
            viewFactory.makeCegoriesView(
                state: $store.state.categoriesState,
                action: store.dispatch(action:)
            )
        )
        .navigationSplitViewColumnWidth(360)
    }
    
    private var homeView: some View {
        AnyView(
            viewFactory.makeHomeView(
                state: $store.state.homeState,
                action: store.dispatch(action:)
            )
        )
        .navigationSplitViewColumnWidth(360)
    }
    
    private var transactionsView: some View {
        AnyView(
            viewFactory.makeTransactionsView(
                state: $store.state.transactionsState,
                action: store.dispatch(action:)
            )
        )
        .navigationSplitViewColumnWidth(360)
    }
    
    private var settingsView: some View {
        AnyView(
            viewFactory.makeSettingsView(
                state: $store.state.settingsState,
                action: store.dispatch(action:)
            )
        )
        .navigationSplitViewColumnWidth(360)
    }
    
    private var detailCategoriesView: some View {
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
    }
    
    private var detailTransactionsView: some View {
        RefdsRoutingReduxView(
            router: $store.state.homeRouter,
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
        .navigationSplitViewColumnWidth(min: 450, ideal: 450)
    }
    
    private var detailAddTransactionView: some View {
        RefdsRoutingReduxView(
            router: $store.state.transactionsRouter,
            state: bindingState,
            action: store.dispatch(action:)
        ) {
            AnyView(
                viewFactory.makeAddTransactionView(
                    state: $store.state.addTransactionState,
                    action: store.dispatch(action:)
                )
            )
        }
        .navigationSplitViewColumnWidth(min: 450, ideal: 450)
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
