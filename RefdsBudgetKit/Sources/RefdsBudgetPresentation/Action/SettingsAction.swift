import Foundation
import RefdsRedux

public enum SettingsAction: RefdsReduxAction {
    case fetchData
    case updateData
    case receiveData(state: SettingsStateProtocol)
}
