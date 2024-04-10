import Foundation
import RefdsUI
import RefdsBudgetData

public extension RefdsBudgetError {
    var toast: RefdsToastViewData? {
        guard let message = message else { return nil }
        return .init(message: message)
    }
}
