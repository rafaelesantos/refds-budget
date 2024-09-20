import Foundation
import CoreData
import RefdsShared
import Domain

public struct SettingsModelMock: SettingsModelProtocol {
    public var date: Date = .random
    public var theme: String = .someWord()
    public var icon: String = RefdsIconSymbol.random.rawValue
    public var isAnimatedIcon: Bool = .random()
    public var appearence: Double = .zero
    public var hasAuthRequest: Bool = .random()
    public var hasPrivacyMode: Bool = .random()
    public var notifications: Bool = .random()
    public var reminderNotification: Bool = .random()
    public var warningNotification: Bool = .random()
    public var breakingNotification: Bool = .random()
    public var currentWarningNotificationAppears: [UUID] = []
    public var currentBreakingNotificationAppears: [UUID] = []
    public var liveActivity: UUID = .init()
    public var isPro: Bool = .random()
    
    public init() {}
    
    public func getEntity(for context: NSManagedObjectContext) -> SettingsEntity {
        SettingsEntity(model: self, for: context)
    }
}
