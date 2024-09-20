import Foundation
import RefdsRedux

public protocol ImportStateProtocol: RefdsReduxState {
    var url: URL { get set }
    var model: FileModelProtocol { get set }
    var isLoading: Bool { get set }
    var error: RefdsBudgetError? { get set }
}
