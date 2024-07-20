import Foundation
import CoreData

@objc(SettingsEntity)
public class SettingsEntity: NSManagedObject, SettingsModelProtocol {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingsEntity> {
        return NSFetchRequest<SettingsEntity>(entityName: "SettingsEntity")
    }

    @NSManaged public var date: Date
    @NSManaged public var theme: String
    @NSManaged public var icon: String
    @NSManaged public var isAnimatedIcon: Bool
    @NSManaged public var appearence: Double
    @NSManaged public var hasAuthRequest: Bool
    @NSManaged public var hasPrivacyMode: Bool
    @NSManaged public var notifications: Bool
    @NSManaged public var reminderNotification: Bool
    @NSManaged public var warningNotification: Bool
    @NSManaged public var breakingNotification: Bool
    @NSManaged public var currentWarningNotificationAppears: [UUID]
    @NSManaged public var currentBreakingNotificationAppears: [UUID]
    @NSManaged public var liveActivity: UUID
    @NSManaged public var isPro: Bool
    
    public convenience init(
        model: SettingsModelProtocol,
        for context: NSManagedObjectContext
    ) {
        self.init(context: context)
        date = model.date
        theme = model.theme
        icon = model.icon
        isAnimatedIcon = model.isAnimatedIcon
        appearence = model.appearence
        hasAuthRequest = model.hasAuthRequest
        hasPrivacyMode = model.hasPrivacyMode
        notifications = model.notifications
        reminderNotification = model.reminderNotification
        warningNotification = model.warningNotification
        breakingNotification = model.breakingNotification
        currentWarningNotificationAppears = model.currentWarningNotificationAppears
        currentBreakingNotificationAppears = model.currentBreakingNotificationAppears
        liveActivity = model.liveActivity
        isPro = model.isPro
    }
    
    public func getEntity(for context: NSManagedObjectContext) -> SettingsEntity {
        self
    }
}
