import SwiftUI
import RefdsBudgetResource

public protocol SettingsUseCase {
    func getSettings() -> SettingsEntity
    func addSettings(
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
    ) throws
}
