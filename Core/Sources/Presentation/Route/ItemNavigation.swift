import SwiftUI
import Domain

private struct ItemNavigationEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<NavigationItem?>?
}

public extension EnvironmentValues {
    var navigationItem: Binding<NavigationItem?>? {
        get { self[ItemNavigationEnvironmentKey.self] }
        set { self[ItemNavigationEnvironmentKey.self] = newValue }
    }
}
