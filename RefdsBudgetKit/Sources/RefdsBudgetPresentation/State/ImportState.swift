import SwiftUI
import StoreKit
import RefdsRedux
import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetResource

public protocol ImportStateProtocol {
    var url: URL { get set }
    var model: FileModel { get set }
    var isLoading: Bool { get set }
    var error: RefdsBudgetError? { get set }
}

public struct ImportState: ImportStateProtocol {
    public var url: URL
    public var model: FileModel
    public var isLoading: Bool
    public var error: RefdsBudgetError?
    
    public init(
        url: URL,
        model: FileModel,
        isLoading: Bool = false
    ) {
        self.url = url
        self.model = model
        self.isLoading = isLoading
    }
}
