import Foundation
import SwiftUI
import RefdsShared
import CoreData

public class TransactionEntityMock {
    public static func value(for context: NSManagedObjectContext) -> TransactionEntity {
        let entity = TransactionEntity(context: context)
        entity.amount = .random(in: 5 ... 2000)
        entity.category = .init()
        entity.date = Date().timestamp
        entity.id = .init()
        entity.message = .someParagraph()
        return entity
    }
}
