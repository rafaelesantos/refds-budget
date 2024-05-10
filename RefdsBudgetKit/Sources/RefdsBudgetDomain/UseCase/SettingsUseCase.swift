import SwiftUI
import RefdsBudgetResource

public protocol SettingsUseCase {
    func getSettings() -> SettingsEntity
    func addSettings(
        theme: Color?,
        icon: ApplicationIcon,
        appearence: Double?,
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
