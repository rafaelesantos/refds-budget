import Foundation
import RefdsShared
import RefdsBudgetDomain

public struct FilterViewDataMock: FilterViewDataProtocol {
    public var canChangePage: Bool = true
    public var isDateFilter: Bool = .random()
    public var date: Date = .random
    public var currentPage: Int = .random(in: 1 ... 3)
    public var amountPage: Int = .random(in: 1 ... 30)
    public var searchText: String = .someWord()
    public var selectedItems: Set<String> = []
    public var items: [FilterItem] = [
        .date,
        .categories((1 ... 10).map { _ in FilterRowViewDataMock() }),
        .status((1 ... 10).map { _ in FilterRowViewDataMock() }),
        .tags((1 ... 10).map { _ in FilterRowViewDataMock() })
    ]
    
    public init() {}
}
