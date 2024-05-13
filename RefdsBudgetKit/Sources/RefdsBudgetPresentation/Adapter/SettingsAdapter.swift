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
        let colorScheme: ColorScheme? = entity.appearence == .zero ? .none : entity.appearence == 1 ? .light : .dark
        let tintColor = Color(hex: entity.theme)
        let icon = Asset(rawValue: entity.icon) ?? .default
        return SettingsState(
            isLoading: false,
            colorScheme: colorScheme,
            tintColor: tintColor,
            hasAuthRequest: entity.hasAuthRequest,
            hasPrivacyMode: entity.hasPrivacyMode,
            icon: icon,
            error: nil
        )
    }
}
