import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import Domain

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
        case .fetchData: fetchData(with: state, on: completion)
        case .updateData: updateData(with: state, on: completion)
        case let .share(budgets, categories, transactions):
            share(
                budgets: budgets,
                categories: categories,
                transactions: transactions,
                on: completion
            )
        default: break
        }
    }
    
    private func fetchData(
        with state: SettingsStateProtocol,
        on completion: @escaping (SettingsAction) -> Void
    ) {
        let settingsEntity = settingsRepository.getSettings()
        let settingsAdapted = settingsAdapter.adapt(
            model: settingsEntity,
            currentState: state
        )
        completion(.receiveData(state: settingsAdapted))
    }
    
    private func updateData(
        with state: SettingsStateProtocol,
        on completion: @escaping (SettingsAction) -> Void
    ) {
        do {
            let appearance: Int = state.colorScheme == .none ? .zero : state.colorScheme == .light ? 1 : 2
            try settingsRepository.addSettings(
                theme: state.tintColor,
                icon: state.icon,
                appearance: Double(appearance),
                hasAuthRequest: state.hasAuthRequest,
                hasPrivacyMode: state.hasPrivacyMode,
                notifications: nil,
                reminderNotification: nil,
                warningNotification: nil,
                breakingNotification: nil,
                currentWarningNotificationAppears: nil,
                currentBreakingNotificationAppears: nil,
                liveActivity: nil,
                isPro: false
            )
            updateAppIcon(for: state.icon.id, on: completion)
            completion(.fetchData)
        } catch {
            completion(.updateError(error: .cantSaveOnDatabase))
        }
    }
    
    private func share(
        budgets: Set<UUID>,
        categories: Set<UUID>,
        transactions: Set<UUID>,
        on completion: @escaping (SettingsAction) -> Void
    ) {
        let url = FileFactory.shared.getFileURL(
            budgetsId: budgets,
            categoriesId: categories,
            transactionsId: transactions
        )
        completion(.updateShare(url))
    }
    
    private func updateAppIcon(
        for name: String,
        on completion: @escaping (SettingsAction) -> Void
    ) {
        Task {
            do {
                guard await UIApplication.shared.alternateIconName != name else { return }
                try await UIApplication.shared.setAlternateIconName(name)
            } catch {
                completion(.updateError(error: .iconUpdate))
            }
        }
    }
}
