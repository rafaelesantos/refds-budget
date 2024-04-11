import SwiftUI
import RefdsRedux
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetPresentation
import RefdsBudgetUI

struct ContentView: View {
    @StateObject private var store: RefdsReduxStore<CategoriesStateProtocol> = .production(
        reducer: CategoriesReducer().reduce,
        state: CategoriesState()
    )
    
    var body: some View {
        NavigationStack {
            CategoriesView(state: $store.state) {
                store.dispatch(action: $0)
            }
        }
    }
}

#Preview {
    ContentView()
}
