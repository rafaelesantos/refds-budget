import Foundation
import SwiftUI

public protocol SettingsUseCase {
    func getSettings() -> SettingsEntity
    func addSettings(
        theme: Color?,
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
