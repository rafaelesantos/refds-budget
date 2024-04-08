import Foundation
import RefdsRedux
import RefdsBudgetData

public protocol TransactionsStateProtocol: RefdsReduxState {
    
}

public struct TransactionsState: TransactionsStateProtocol {
    public var isLoading: Bool
    public var searchText: String
    public var isFilterEnable: Bool
    public var date: Date
    public var selectedCategories: [CategoryStateProtocol]
    public var categories: [CategoryStateProtocol]
    public var transaction: [TransactionStateProtocol]
    public var currentValues: CurrentValuesStateProtocol
    public var error: RefdsBudgetError?
}
