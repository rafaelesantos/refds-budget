import Foundation
import RefdsRedux

public enum SettingsAction: RefdsReduxAction {
    case fetchData
    case updateData
    case receiveData(state: SettingsStateProtocol)
    case updateShare(URL)
    case updateError(error: RefdsBudgetError?)
    case share(
        budgets: Set<UUID>,
        categories: Set<UUID>,
        transactions: Set<UUID>
    )
}
