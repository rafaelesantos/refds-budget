import SwiftUI
import RefdsRedux
import RefdsRouter
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetPresentation
import RefdsBudgetUI

struct ContentView: View {
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
    
    var body: some View {
        RefdsRoutingReduxView(
            router: $store.state.router,
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
    }
}

#Preview {
    ContentView()
}
