import SwiftUI
import Domain
import Resource

public struct SettingsState: SettingsStateProtocol {
    public var isLoading: Bool
    public var colorScheme: ColorScheme?
    public var tintColor: Color
    public var hasAuthRequest: Bool
    public var hasPrivacyMode: Bool
    public var icon: Asset
    public var icons: [Asset]
    public var share: URL?
    public var showDocumentPicker: Bool = false
    public var error: RefdsBudgetError?
    
    public init(
        isLoading: Bool = true,
        colorScheme: ColorScheme? = nil,
        tintColor: Color = .green,
        hasAuthRequest: Bool = false,
        hasPrivacyMode: Bool = false,
        icon: Asset = .appIcon,
        icons: [Asset] = Asset.allCases,
        error: RefdsBudgetError? = nil
    ) {
        self.isLoading = isLoading
        self.colorScheme = colorScheme
        self.tintColor = tintColor
        self.hasAuthRequest = hasAuthRequest
        self.hasPrivacyMode = hasPrivacyMode
        self.icon = icon
        self.icons = icons
        self.error = error
    }
}

public extension Optional<ColorScheme> {
    var description: String {
        switch self {
        case .light: return .localizable(by: .settingsRowAppearanceLight)
        case .dark: return .localizable(by: .settingsRowAppearanceDark)
        default: return .localizable(by: .settingsRowAppearanceSystem)
        }
    }
}

private struct PrivacyModeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

private struct ProEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

public extension EnvironmentValues {
    var privacyMode: Bool {
        get { self[PrivacyModeEnvironmentKey.self] }
        set { self[PrivacyModeEnvironmentKey.self] = newValue }
    }
    
    var isPro: Bool {
        get { self[ProEnvironmentKey.self] }
        set { self[ProEnvironmentKey.self] = newValue }
    }
}
