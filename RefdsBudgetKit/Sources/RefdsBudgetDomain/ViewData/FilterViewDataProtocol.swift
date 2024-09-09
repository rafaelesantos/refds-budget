import Foundation

public protocol FilterViewDataProtocol {
    var isDateFilter: Bool { get set }
    var date: Date { get set }
    var currentPage: Int { get set }
    var canChangePage: Bool { get set }
    var amountPage: Int { get set }
    var searchText: String { get set }
    var selectedItems: Set<String> { get set }
    var items: [FilterItem] { get set }
}
