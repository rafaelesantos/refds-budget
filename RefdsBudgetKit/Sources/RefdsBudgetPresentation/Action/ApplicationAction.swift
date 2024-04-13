import Foundation
import RefdsRedux
import RefdsRouter

public enum ApplicationAction: RefdsReduxAction {
    case updateRoute(ApplicationRoute)
    case dismiss
}
