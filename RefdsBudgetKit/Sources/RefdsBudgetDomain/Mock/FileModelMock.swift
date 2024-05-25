import Foundation

public struct FileModelMock {
    public static var value: FileModel {
        FileModel(
            budgets: (1 ... 10).map { _ in BudgetModelMock.value },
            categories: (1 ... 10).map { _ in CategoryModelMock.value },
            transactions: (1 ... 10).map { _ in TransactionModelMock.value }
        )
    }
}
