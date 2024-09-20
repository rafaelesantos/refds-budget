import Foundation
import Domain

struct FilterViewData: FilterViewDataProtocol {
    var isDateFilter: Bool
    var date: Date
    var currentPage: Int
    var canChangePage: Bool
    var amountPage: Int
    var searchText: String
    var selectedItems: Set<String>
    var items: [FilterItem]
    
    init(
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
