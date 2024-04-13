import Foundation
import RefdsRedux
import RefdsShared
import RefdsBudgetData

public protocol CategoriesStateProtocol: RefdsReduxState {
    var isLoading: Bool { get set }
    var searchText: String { get set }
    var isFilterEnable: Bool { get set }
    var date: Date { get set }
    var categories: [CategoryRowViewDataProtocol] { get set }
    var isEmptyCategories: Bool { get set }
    var isEmptyBudgets: Bool { get }
    var balance: BalanceStateProtocol? { get set }
    var error: RefdsBudgetError? { get set }
}

public struct CategoriesState: CategoriesStateProtocol {
    public var isLoading: Bool
    public var searchText: String
    public var isFilterEnable: Bool
    public var date: Date
    public var categories: [CategoryRowViewDataProtocol]
    public var isEmptyCategories: Bool
    public var balance: BalanceStateProtocol?
    public var error: RefdsBudgetError?
    
    public var isEmptyBudgets: Bool { categories.isEmpty }
    
    public init(
        isLoading: Bool = true,
        searchText: String = "",
        isFilterEnable: Bool = true,
        date: Date = .current,
        categories: [CategoryRowViewDataProtocol] = [],
        isEmptyCategories: Bool = true,
        balance: BalanceStateProtocol? = nil
    ) {
        self.isLoading = isLoading
        self.searchText = searchText
        self.isFilterEnable = isFilterEnable
        self.date = date
        self.categories = categories
        self.isEmptyCategories = isEmptyCategories
        self.balance = balance
    }
}
