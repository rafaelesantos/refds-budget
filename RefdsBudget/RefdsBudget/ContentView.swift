import SwiftUI
import RefdsRedux
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetPresentation
import RefdsBudgetUI

struct ContentView: View {
    @StateObject private var store: RefdsReduxStore<BudgetStateProtocol>
    
    init() {
        RefdsContainer.register(type: RefdsBudgetDatabaseProtocol.self) { RefdsBudgetDatabase() }
        RefdsContainer.register(type: CategoryUseCase.self) { LocalCategoryRepository() }
        RefdsContainer.register(type: CategoryAdapterProtocol.self) { CategoryAdapter() }
        
        _store = StateObject(wrappedValue: RefdsReduxStore(reducer: AddBudgetReducer().reduce, state: AddBudgetState(), middlewares: [CategoryMiddleware().middleware]))
    }
    
    var body: some View {
        AddBudgetView(state: $store.state) {
            store.dispatch(action: $0)
        }
    }
}

#Preview {
    ContentView()
}
