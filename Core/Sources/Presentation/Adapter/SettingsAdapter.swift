import SwiftUI
import RefdsShared
import Domain
import Resource

public protocol SettingsAdapterProtocol {
    func adapt(
        model: SettingsModelProtocol,
        currentState: SettingsStateProtocol
    ) -> SettingsStateProtocol
}

public final class SettingsAdapter: SettingsAdapterProtocol {
    public init() {}
    
    public func adapt(
        model: SettingsModelProtocol,
        currentState: SettingsStateProtocol
    ) -> SettingsStateProtocol {
        let colorScheme: ColorScheme? = model.appearence == .zero ? .none : model.appearence == 1 ? .light : .dark
        let tintColor = Color(hex: model.theme)
        let icon = Asset(rawValue: model.icon) ?? .appIcon
        var state = currentState
        state.isLoading = false
        state.colorScheme = colorScheme
        state.tintColor = tintColor
        state.hasAuthRequest = model.hasAuthRequest
        state.hasPrivacyMode = model.hasPrivacyMode
        state.icon = icon
        return state
    }
}
