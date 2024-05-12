import Foundation
import CoreData

@objc(SettingsEntity)
public class SettingsEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingsEntity> {
        return NSFetchRequest<SettingsEntity>(entityName: "SettingsEntity")
    }

    @NSManaged public var date: Date
    @NSManaged public var theme: String
    @NSManaged public var icon: String
    @NSManaged public var appearence: Double
    @NSManaged public var hasAuthRequest: Bool
    @NSManaged public var notifications: Bool
    @NSManaged public var reminderNotification: Bool
    @NSManaged public var warningNotification: Bool
    @NSManaged public var breakingNotification: Bool
    @NSManaged public var currentWarningNotificationAppears: [UUID]
    @NSManaged public var currentBreakingNotificationAppears: [UUID]
    @NSManaged public var liveActivity: UUID
    @NSManaged public var isPro: Bool
}
