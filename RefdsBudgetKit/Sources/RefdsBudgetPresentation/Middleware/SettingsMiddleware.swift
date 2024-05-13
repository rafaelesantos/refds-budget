import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class SettingsMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var settingsRepository: SettingsUseCase
    @RefdsInjection private var settingsAdapter: SettingsAdapterProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        switch action {
        case let action as SettingsAction: self.handler(with: state.settingsState, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: SettingsStateProtocol,
        for action: SettingsAction,
        on completion: @escaping (SettingsAction) -> Void
    ) {
        switch action {
        case .fetchData: fetchData(on: completion)
        case .updateData: updateData(with: state, on: completion)
        default: break
        }
    }
    
    private func fetchData(on completion: @escaping (SettingsAction) -> Void) {
        let settingsEntity = settingsRepository.getSettings()
        let settingsAdapted = settingsAdapter.adapt(entity: settingsEntity)
        completion(.receiveData(state: settingsAdapted))
    }
    
    private func updateData(
        with state: SettingsStateProtocol,
        on completion: @escaping (SettingsAction) -> Void
    ) {
        do {
            let appearence: Int = state.colorScheme == .none ? .zero : state.colorScheme == .light ? 1 : 2
            try settingsRepository.addSettings(
                theme: state.tintColor,
                icon: state.icon,
                appearence: Double(appearence),
                hasAuthRequest: state.hasAuthRequest,
                hasPrivacyMode: state.hasPrivacyMode,
                notifications: nil,
                reminderNotification: nil,
                warningNotification: nil,
                breakingNotification: nil,
                currentWarningNotificationAppears: nil,
                currentBreakingNotificationAppears: nil,
                liveActivity: nil,
                isPro: nil
            )
            completion(.fetchData)
        } catch {
            
        }
    }
}
