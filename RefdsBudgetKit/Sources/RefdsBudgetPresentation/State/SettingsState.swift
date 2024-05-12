import SwiftUI
import RefdsRedux
import RefdsBudgetData
import RefdsBudgetResource

public protocol SettingsStateProtocol: RefdsReduxState {
    var isLoading: Bool { get set }
    var colorScheme: ColorScheme? { get set }
    var tintColor: Color { get set }
    var icon: Asset { get set }
    var icons: [Asset] { get set }
    var error: RefdsBudgetError? { get set }
}

public struct SettingsState: SettingsStateProtocol {
    public var isLoading: Bool
    public var colorScheme: ColorScheme?
    public var tintColor: Color
    public var icon: Asset
    public var icons: [Asset]
    public var error: RefdsBudgetError?
    
    public init(
        isLoading: Bool = true,
        colorScheme: ColorScheme? = nil,
        tintColor: Color = .green,
        icon: Asset = .default,
        icons: [Asset] = Asset.allCases,
        error: RefdsBudgetError? = nil
    ) {
        self.isLoading = isLoading
        self.colorScheme = colorScheme
        self.tintColor = tintColor
        self.icon = icon
        self.icons = icons
        self.error = error
    }
}

public extension Optional<ColorScheme> {
    var description: String {
        switch self {
        case .light: return "Claro"
        case .dark: return "Escuro"
        default: return "Sistema"
        }
    }
}
