import SwiftUI
import StoreKit
import RefdsRedux
import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetResource

public protocol ImportStateProtocol {
    var url: URL { get set }
    var model: FileModelProtocol { get set }
    var isLoading: Bool { get set }
    var error: RefdsBudgetError? { get set }
}

public struct ImportState: ImportStateProtocol {
    public var url: URL
    public var model: FileModelProtocol
    public var isLoading: Bool
    public var error: RefdsBudgetError?
    
    public init(
        url: URL,
        model: FileModelProtocol,
        isLoading: Bool = false
    ) {
        self.url = url
        self.model = model
        self.isLoading = isLoading
    }
}
