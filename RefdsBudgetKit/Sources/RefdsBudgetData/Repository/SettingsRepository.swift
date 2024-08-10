import Foundation
import SwiftUI
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class SettingsRepository: SettingsUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getSettings() -> SettingsModelProtocol {
        database.viewContext.performAndWait {
            let request = SettingsEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            guard let entity = try? database.viewContext.fetch(request).last else {
                let entity = SettingsEntity(context: database.viewContext)
                entity.date = .current
                entity.theme = "#28CD41"
                entity.icon = Asset.appIcon.rawValue
                entity.isAnimatedIcon = false
                entity.appearence = .zero
                entity.hasAuthRequest = false
                entity.hasPrivacyMode = false
                entity.notifications = false
                entity.reminderNotification = false
                entity.warningNotification = false
                entity.breakingNotification = false
                entity.currentWarningNotificationAppears = [.init()]
                entity.currentBreakingNotificationAppears = [.init()]
                entity.liveActivity = .init()
                entity.isPro = false
                try? database.viewContext.save()
                
                return SettingsModel(entity: entity)
            }
            return SettingsModel(entity: entity)
        }
    }
    
    public func addSettings(
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
    ) throws {
        try database.viewContext.performAndWait {
            let model = getSettings()
            let entity = model.getEntity(for: self.database.viewContext)
            entity.date = .current
            entity.theme = theme?.asHex ?? entity.theme
            entity.icon = icon.rawValue
            entity.isAnimatedIcon = isAnimatedIcon ?? entity.isAnimatedIcon
            entity.appearence = appearence ?? entity.appearence
            entity.hasAuthRequest = hasAuthRequest
            entity.hasPrivacyMode = hasPrivacyMode
            entity.notifications = notifications ?? entity.notifications
            entity.reminderNotification = reminderNotification ?? entity.reminderNotification
            entity.warningNotification = warningNotification ?? entity.warningNotification
            entity.breakingNotification = breakingNotification ?? entity.breakingNotification
            entity.currentWarningNotificationAppears = currentWarningNotificationAppears ?? entity.currentWarningNotificationAppears
            entity.currentBreakingNotificationAppears = currentBreakingNotificationAppears ?? entity.currentBreakingNotificationAppears
            entity.liveActivity = liveActivity ?? entity.liveActivity
            entity.isPro = isPro ?? entity.isPro
            try self.database.viewContext.save()
        }
    }
}
