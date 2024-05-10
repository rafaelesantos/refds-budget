import Foundation
import SwiftUI
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class LocalSettingsRepository: SettingsUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getSettings() -> SettingsEntity {
        let request = SettingsEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        guard let settings = try? database.viewContext.fetch(request).last else {
            let settings = SettingsEntity(context: database.viewContext)
            settings.date = .current
            settings.theme = Color.green.asHex()
            settings.icon = ApplicationIcon.default.rawValue
            settings.appearence = .zero
            settings.notifications = true
            settings.reminderNotification = true
            settings.warningNotification = true
            settings.breakingNotification = true
            settings.currentWarningNotificationAppears = [.init()]
            settings.currentBreakingNotificationAppears = [.init()]
            settings.liveActivity = .init()
            settings.isPro = false
            try? database.viewContext.save()
            return settings
        }
        return settings
    }
    
    public func addSettings(
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
    ) throws {
        let settings = getSettings()
        settings.date = .current
        settings.theme = theme?.asHex() ?? settings.theme
        settings.icon = icon.rawValue
        settings.appearence = appearence ?? settings.appearence
        settings.notifications = notifications ?? settings.notifications
        settings.reminderNotification = reminderNotification ?? settings.reminderNotification
        settings.warningNotification = warningNotification ?? settings.warningNotification
        settings.breakingNotification = breakingNotification ?? settings.breakingNotification
        settings.currentWarningNotificationAppears = currentWarningNotificationAppears ?? settings.currentWarningNotificationAppears
        settings.currentBreakingNotificationAppears = currentBreakingNotificationAppears ?? settings.currentBreakingNotificationAppears
        settings.liveActivity = liveActivity ?? settings.liveActivity
        settings.isPro = isPro ?? settings.isPro
        try database.viewContext.save()
    }
}
