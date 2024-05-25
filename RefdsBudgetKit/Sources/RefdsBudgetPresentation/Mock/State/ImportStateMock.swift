import Foundation
import RefdsBudgetDomain
import RefdsBudgetData

public struct ImportStateMock: ImportStateProtocol {
    public var url: URL = .applicationDirectory
    public var model: FileModel = FileModelMock.value
    public var isLoading: Bool = false
    public var error: RefdsBudgetError?
    
    public init() {}
}
