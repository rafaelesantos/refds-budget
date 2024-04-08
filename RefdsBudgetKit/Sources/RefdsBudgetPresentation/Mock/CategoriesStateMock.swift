import Foundation
import RefdsBudgetData

public struct CategoriesStateMock: CategoriesStateProtocol {
    public var isLoading: Bool = true
    public var searchText: String = ""
    public var isFilterEnable: Bool = .random()
    public var date: Date = .current
    public var categories: [CategoryStateProtocol] = (1 ... 4).map { _ in AddCategoryStateMock() }
    public var currentValues: CurrentValuesStateProtocol = CurrentValuesStateMock()
    public var error: RefdsBudgetError? = Bool.random() ? nil : .notFoundCategory
    
    public init() {}
}
