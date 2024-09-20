import SwiftUI
import StoreKit
import BackgroundTasks
import RefdsAuth
import RefdsRedux
import RefdsRouter
import RefdsInjection
import RefdsWelcome
import Domain
import Data
import Presentation
import UserInterface

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @StateObject private var store = EnvironmentConfiguration.store
    @StateObject private var welcome = WelcomeViewData()
    
    @AppStorage("isWelcomePresented") private var isWelcomePresented = false
    
    private var viewFactory = ViewFactory()
    
    init() {
        RefdsContainer.register(type: ViewFactoryProtocol.self) { viewFactory }
    }
    
    var body: some View {
        if !isWelcomePresented {
            RefdsWelcomeScreen(viewData: welcome.viewData)
                .accentColor(store.state.settingsState.tintColor)
                .preferredColorScheme(store.state.settingsState.colorScheme)
                .onAppear { reloadSettings() }
                .onChange(of: store.state.settingsState.isLoading) { setupWelcome() }
        } else if welcome.isLoading {
            RefdsWelcomeSplashScreen(
                isLoading: welcome.isLoading,
                viewData: welcome.header
            )
            .accentColor(store.state.settingsState.tintColor)
            .preferredColorScheme(store.state.settingsState.colorScheme)
            .onAppear { reloadSettings() }
            .onChange(of: store.state.settingsState.isLoading) { dismissSplash() }
        } else {
            contentView
                .environmentObject(store)
                .environment(\.privacyMode, store.state.settingsState.hasPrivacyMode)
                .preferredColorScheme(store.state.settingsState.colorScheme)
                .tint(store.state.settingsState.tintColor)
                .onChange(of: scenePhase) { handlerScenePhase() }
                .refdsAuth(
                    isAuthenticated: bindingIsAuthenticated,
                    applicationIcon: store.state.settingsState.icon.image
                )
                .accentColor(store.state.settingsState.tintColor)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch horizontalSizeClass {
        case .compact: TabNavigationView()
        default: SideNavigationView()
        }
    }
    
    private var bindingIsAuthenticated: Binding<Bool> {
        Binding {
            guard store.state.settingsState.hasAuthRequest else { return true }
            return welcome.isAuthenticated
        } set: {
            welcome.isAuthenticated = $0
        }
    }
    
    private func reloadSettings() {
        setupIntelligence()
        store.state.settingsState = SettingsState()
        store.dispatch(action: SettingsAction.fetchData)
    }
    
    private func setupIntelligence() {
        let intelligence = RefdsContainer.resolve(type: IntelligenceProtocol.self)
        DispatchQueue.global(qos: .utility).async {
            intelligence.training(
                for: .ultra,
                with: nil,
                on: { print($0, $1, $2) }
            )
        }
    }
    
    private func dismissSplash() {
        setupWelcome()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation { welcome.isLoading = false }
        }
    }
    
    private func setupWelcome() {
        welcome.header.applicationIcon = store.state.settingsState.icon.image
        welcome.footer.action = {
            withAnimation { isWelcomePresented = true }
        }
        welcome.viewData.footer = welcome.footer
        welcome.viewData.header = welcome.header
    }
    
    private func handlerScenePhase() {
        switch scenePhase {
        case .active: break
        default: welcome.isAuthenticated = false
        }
    }
}
