import SwiftUI
import RefdsRedux

public protocol ProfileStateProtocol: RefdsReduxState {
    var userName: String? { get set }
    var userPhoto: Data? { get set }
}
