import Foundation
import RefdsShared

public struct BudgetModelMock {
    public static var value: BudgetModel {
        BudgetModel(
            amount: .random(in: 100 ... 1000),
            category: .init(),
            date: Date.current.timeIntervalSince1970,
            id: .init(),
            message: .someParagraph()
        )
    }
}
