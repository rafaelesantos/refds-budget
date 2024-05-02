import SwiftUI
import RefdsRedux
import RefdsRouter
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetPresentation
import RefdsBudgetUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @StateObject private var store = RefdsReduxStoreFactory().production
    private var viewFactory = ViewFactory()
    
    init() {
        RefdsContainer.register(type: ViewFactoryProtocol.self) { viewFactory }
    }
    
    var body: some View {
        switch horizontalSizeClass {
        case .compact: TabNavigationView().environmentObject(store)
        default: SideNavigationView().environmentObject(store)
        }
    }
}
