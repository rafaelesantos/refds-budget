import Foundation
import SwiftUI
import RefdsShared
import CoreData

public class SettingsEntityMock {
    public static func value(for context: NSManagedObjectContext) -> SettingsEntity {
        let entity = SettingsEntity(context: context)
        entity.date = Date()
        entity.theme = .someWord()
        entity.appearence = .zero
        entity.notifications = .random()
        entity.reminderNotification = .random()
        entity.warningNotification = .random()
        entity.breakingNotification = .random()
        entity.currentWarningNotificationAppears = (1 ... 4).map { _ in .init() }
        entity.currentBreakingNotificationAppears = (1 ... 4).map { _ in .init() }
        entity.liveActivity = .init()
        entity.isPro = .random()
        return entity
    }
}
