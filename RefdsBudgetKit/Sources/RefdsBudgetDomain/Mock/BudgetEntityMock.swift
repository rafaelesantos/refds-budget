import Foundation
import SwiftUI
import RefdsShared
import CoreData

public class BudgetEntityMock {
    public static func value(for context: NSManagedObjectContext) -> BudgetEntity {
        let entity = BudgetEntity(context: context)
        entity.amount = .random(in: 250 ... 750)
        entity.category = .init()
        entity.date = Date().timestamp
        entity.id = .init()
        entity.message = .someParagraph()
        return entity
    }
}
