import Foundation
import RefdsShared

public struct TransactionModelMock {
    public static var value: TransactionModel {
        TransactionModel(
            amount: .random(in: 10 ... 300),
            category: .init(),
            date: Date.current.timeIntervalSince1970,
            id: .init(),
            message: .someParagraph(),
            status: TransactionStatus.spend.rawValue
        )
    }
}
