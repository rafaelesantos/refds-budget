import Foundation
import CoreData
import RefdsShared

public protocol SettingsModelProtocol {
    var date: Date { get set }
    var theme: String { get set }
    var icon: String { get set }
    var isAnimatedIcon: Bool { get set }
    var appearence: Double { get set }
    var hasAuthRequest: Bool { get set }
    var hasPrivacyMode: Bool { get set }
    var notifications: Bool { get set }
    var reminderNotification: Bool { get set }
    var warningNotification: Bool { get set }
    var breakingNotification: Bool { get set }
    var currentWarningNotificationAppears: [UUID] { get set }
    var currentBreakingNotificationAppears: [UUID] { get set }
    var liveActivity: UUID { get set }
    var isPro: Bool { get set }
    
    func getEntity(for context: NSManagedObjectContext) -> SettingsEntity
}

public struct SettingsModel: SettingsModelProtocol, RefdsModel {
    public var date: Date
    public var theme: String
    public var icon: String
    public var isAnimatedIcon: Bool
    public var appearence: Double
    public var hasAuthRequest: Bool
    public var hasPrivacyMode: Bool
    public var notifications: Bool
    public var reminderNotification: Bool
    public var warningNotification: Bool
    public var breakingNotification: Bool
    public var currentWarningNotificationAppears: [UUID]
    public var currentBreakingNotificationAppears: [UUID]
    public var liveActivity: UUID
    public var isPro: Bool
    
    public init(
        date: Date,
        theme: String,
        icon: String,
        isAnimatedIcon: Bool,
        appearence: Double,
        hasAuthRequest: Bool,
        hasPrivacyMode: Bool,
        notifications: Bool,
        reminderNotification: Bool,
        warningNotification: Bool,
        breakingNotification: Bool,
        currentWarningNotificationAppears: [UUID],
        currentBreakingNotificationAppears: [UUID],
        liveActivity: UUID,
        isPro: Bool
    ) {
        self.date = date
        self.theme = theme
        self.icon = icon
        self.isAnimatedIcon = isAnimatedIcon
        self.appearence = appearence
        self.hasAuthRequest = hasAuthRequest
        self.hasPrivacyMode = hasPrivacyMode
        self.notifications = notifications
        self.reminderNotification = reminderNotification
        self.warningNotification = warningNotification
        self.breakingNotification = breakingNotification
        self.currentWarningNotificationAppears = currentWarningNotificationAppears
        self.currentBreakingNotificationAppears = currentBreakingNotificationAppears
        self.liveActivity = liveActivity
        self.isPro = isPro
    }
    
    public init(entity: SettingsEntity) {
        self.date = entity.date
        self.theme = entity.theme
        self.icon = entity.icon
        self.isAnimatedIcon = entity.isAnimatedIcon
        self.appearence = entity.appearence
        self.hasAuthRequest = entity.hasAuthRequest
        self.hasPrivacyMode = entity.hasPrivacyMode
        self.notifications = entity.notifications
        self.reminderNotification = entity.reminderNotification
        self.warningNotification = entity.warningNotification
        self.breakingNotification = entity.breakingNotification
        self.currentWarningNotificationAppears = entity.currentWarningNotificationAppears
        self.currentBreakingNotificationAppears = entity.currentBreakingNotificationAppears
        self.liveActivity = entity.liveActivity
        self.isPro = entity.isPro
    }
    
    public func getEntity(for context: NSManagedObjectContext) -> SettingsEntity {
        context.performAndWait {
            let request = SettingsEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            guard let entity = try? context.fetch(request).last else {
                return SettingsEntity(model: self, for: context)
            }
            return entity
        }
    }
}
