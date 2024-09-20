import SwiftUI
import RefdsInjection
import Domain
import Resource

public final class SettingsRepositoryMock: SettingsUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getSettings() -> SettingsModelProtocol {
        SettingsModelMock()
    }
    
    public func addSettings(
        theme: Color?,
        icon: Asset,
        appearance: Double?,
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
