import SwiftUI
import RefdsBudgetResource

public protocol SettingsUseCase {
    func getSettings() -> SettingsModelProtocol
    
    func addSettings(
        theme: Color?,
        icon: Asset,
        isAnimatedIcon: Bool?,
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
