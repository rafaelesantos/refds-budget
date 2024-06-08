import SwiftUI
import RefdsShared
import RefdsBudgetDomain
import RefdsBudgetResource

public protocol SettingsAdapterProtocol {
    func adapt(
        entity: SettingsEntity,
        currentState: SettingsStateProtocol
    ) -> SettingsStateProtocol
}

public final class SettingsAdapter: SettingsAdapterProtocol {
    public init() {}
    
    public func adapt(
        entity: SettingsEntity,
        currentState: SettingsStateProtocol
    ) -> SettingsStateProtocol {
        let colorScheme: ColorScheme? = entity.appearence == .zero ? .none : entity.appearence == 1 ? .light : .dark
        let tintColor = Color(hex: entity.theme)
        let icon = Asset(rawValue: entity.icon) ?? .appIcon
        var state = currentState
        state.isLoading = false
        state.isPro = entity.isPro
        state.colorScheme = colorScheme
        state.tintColor = tintColor
        state.hasAuthRequest = entity.hasAuthRequest
        state.hasPrivacyMode = entity.hasPrivacyMode
        state.icon = icon
        return state
    }
}
