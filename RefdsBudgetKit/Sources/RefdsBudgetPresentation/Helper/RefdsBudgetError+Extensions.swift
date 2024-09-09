import Foundation
import RefdsUI
import RefdsBudgetDomain

public extension RefdsBudgetError {
    var toast: RefdsToastViewData? {
        guard let message = message else { return nil }
        return .init(message: message)
    }
}
