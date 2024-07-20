import Foundation

public struct FileModelMock: FileModelProtocol {
    public var budgets: [BudgetModelProtocol] = (1 ... 10).map { _ in BudgetModelMock() }
    public var categories: [CategoryModelProtocol] = (1 ... 10).map { _ in CategoryModelMock() }
    public var transactions: [TransactionModelProtocol] = (1 ... 10).map { _ in TransactionModelMock() }
    public var url: URL?
    
    public init() {}
}
