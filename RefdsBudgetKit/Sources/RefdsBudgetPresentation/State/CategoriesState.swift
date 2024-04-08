import Foundation
import RefdsRedux
import RefdsShared
import RefdsBudgetData

public protocol CategoriesStateProtocol: RefdsReduxState {
    var isLoading: Bool { get set }
    var searchText: String { get set }
    var isFilterEnable: Bool { get set }
    var date: Date { get set }
    var categories: [CategoryStateProtocol] { get set }
    var currentValues: CurrentValuesStateProtocol { get set }
    var error: RefdsBudgetError? { get set }
}

public struct CategoriesState: CategoriesStateProtocol {
    public var isLoading: Bool
    public var searchText: String
    public var isFilterEnable: Bool
    public var date: Date
    public var categories: [CategoryStateProtocol]
    public var currentValues: CurrentValuesStateProtocol
    public var error: RefdsBudgetError?
    
    public init(
        isLoading: Bool = true,
        searchText: String = "",
        isFilterEnable: Bool = true,
        date: Date = .current,
        categories: [CategoryStateProtocol],
        currentValues: CurrentValuesStateProtocol
    ) {
        self.isLoading = isLoading
        self.searchText = searchText
        self.isFilterEnable = isFilterEnable
        self.date = date
        self.categories = categories
        self.currentValues = currentValues
    }
}
