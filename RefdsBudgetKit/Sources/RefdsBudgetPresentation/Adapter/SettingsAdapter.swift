import SwiftUI
import RefdsShared
import RefdsBudgetDomain
import RefdsBudgetResource

public protocol SettingsAdapterProtocol {
    func adapt(entity: SettingsEntity) -> SettingsStateProtocol
}

public final class SettingsAdapter: SettingsAdapterProtocol {
    public init() {}
    
    public func adapt(entity: SettingsEntity) -> SettingsStateProtocol {
        let colorScheme = ColorScheme(UIUserInterfaceStyle(rawValue: Int(entity.appearence)) ?? .light) ?? .light
        let tintColor = Color(hex: entity.theme)
        let icon = ApplicationIcon(rawValue: entity.icon) ?? .default
        return SettingsState(
            isLoading: false,
            colorScheme: colorScheme,
            tintColor: tintColor,
            icon: icon,
            error: nil
        )
    }
}
