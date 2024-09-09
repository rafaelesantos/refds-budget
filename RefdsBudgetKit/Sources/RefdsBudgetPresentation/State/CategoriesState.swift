import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsBudgetDomain

public protocol CategoriesStateProtocol: RefdsReduxState {
    var isLoading: Bool { get set }
    var filter: FilterViewDataProtocol { get set }
    var categories: [CategoryRowViewDataProtocol] { get set }
    var isEmptyCategories: Bool { get set }
    var isEmptyBudgets: Bool { get }
    var balance: BalanceRowViewDataProtocol? { get set }
    var error: RefdsBudgetError? { get set }
}

public struct CategoriesState: CategoriesStateProtocol {
    public var isLoading: Bool
    public var filter: FilterViewDataProtocol
    public var categories: [CategoryRowViewDataProtocol]
    public var isEmptyCategories: Bool
    public var balance: BalanceRowViewDataProtocol?
    public var error: RefdsBudgetError?
    
    public var isEmptyBudgets: Bool { categories.isEmpty }
    
    public init(
        isLoading: Bool = true,
        filter: FilterViewDataProtocol = FilterViewData(items: [.date]),
        categories: [CategoryRowViewDataProtocol] = [],
        isEmptyCategories: Bool = true,
        balance: BalanceRowViewDataProtocol? = nil,
        error: RefdsBudgetError? = nil
    ) {
        self.isLoading = isLoading
        self.filter = filter
        self.categories = categories
        self.isEmptyCategories = isEmptyCategories
        self.balance = balance
        self.error = error
    }
}
