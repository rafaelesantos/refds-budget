import SwiftUI
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class LocalSettingsRepositoryMock: SettingsUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getSettings() -> SettingsEntity {
        let settings = SettingsEntityMock.value(for: database.viewContext)
        settings.theme = Color.green.asHex()
        settings.appearence = 0.0
        return settings
    }
    
    public func addSettings(
        theme: Color?,
        icon: Asset,
        appearence: Double?,
        hasAuthRequest: Bool,
        hasPrivacyMode: Bool,
        notifications: Bool?,
        reminderNotification: Bool?,
        warningNotification: Bool?,
        breakingNotification: Bool?,
        currentWarningNotificationAppears: [UUID]?,
        currentBreakingNotificationAppears: [UUID]?,
        liveActivity: UUID?,
        isPro: Bool?
    ) throws {}
}
