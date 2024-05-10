import SwiftUI
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class LocalSettingsRepositoryMock: SettingsUseCase {
    @RefdsInjection private var database: RefdsBudgetDatabaseProtocol
    
    public init() {}
    
    public func getSettings() -> SettingsEntity {
        SettingsEntityMock.value(for: database.viewContext)
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
    ) throws {}
}
