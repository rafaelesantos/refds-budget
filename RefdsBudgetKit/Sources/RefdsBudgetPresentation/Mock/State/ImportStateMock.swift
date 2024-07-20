import Foundation
import RefdsBudgetDomain
import RefdsBudgetData

public struct ImportStateMock: ImportStateProtocol {
    public var url: URL = .applicationDirectory
    public var model: FileModelProtocol = FileModelMock()
    public var isLoading: Bool = false
    public var error: RefdsBudgetError?
    
    public init() {}
}
