import Foundation
import RefdsBudgetDomain

public struct FilterViewData: FilterViewDataProtocol {
    public var isDateFilter: Bool
    public var date: Date
    public var currentPage: Int
    public var canChangePage: Bool
    public var amountPage: Int
    public var searchText: String
    public var selectedItems: Set<String>
    public var items: [FilterItem]
    
    public init(
        isDateFilter: Bool = true,
        date: Date = .now,
        currentPage: Int = 1,
        canChangePage: Bool = true,
        amountPage: Int = 2,
        searchText: String = "",
        selectedItems: Set<String> = [],
        items: [FilterItem] = [.date]
    ) {
        self.isDateFilter = isDateFilter
        self.date = date
        self.currentPage = currentPage
        self.canChangePage = canChangePage
        self.amountPage = amountPage
        self.searchText = searchText
        self.selectedItems = selectedItems
        self.items = items
    }
}
