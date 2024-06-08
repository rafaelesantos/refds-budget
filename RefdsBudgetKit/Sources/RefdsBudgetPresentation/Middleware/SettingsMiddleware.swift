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
            entity: settingsEntity,
            currentState: state
        )
        completion(.receiveData(state: settingsAdapted))
    }
    
    private func updateData(
        with state: SettingsStateProtocol,
        on completion: @escaping (SettingsAction) -> Void
    ) {
        do {
            let isPro = !state.purchasedProductsID.isEmpty
            let appearence: Int = isPro ? (state.colorScheme == .none ? .zero : state.colorScheme == .light ? 1 : 2) : .zero
            let tintColor = isPro ? state.tintColor : .green
            let hasAuthRequest = isPro ? state.hasAuthRequest : false
            let hasPrivacyMode = isPro ? state.hasPrivacyMode : false
            try settingsRepository.addSettings(
                theme: tintColor,
                icon: state.icon,
                isAnimatedIcon: state.isAnimatedIcon,
                appearence: Double(appearence),
                hasAuthRequest: hasAuthRequest,
                hasPrivacyMode: hasPrivacyMode,
                notifications: nil,
                reminderNotification: nil,
                warningNotification: nil,
                breakingNotification: nil,
                currentWarningNotificationAppears: nil,
                currentBreakingNotificationAppears: nil,
                liveActivity: nil,
                isPro: isPro
            )
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
}
