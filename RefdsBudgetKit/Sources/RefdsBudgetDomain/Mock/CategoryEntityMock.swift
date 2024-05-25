import Foundation
import SwiftUI
import RefdsShared
import CoreData

public class CategoryEntityMock {
    public static func value(for context: NSManagedObjectContext) -> CategoryEntity {
        let entity = CategoryEntity(context: context)
        entity.budgets = (1 ... 4).map { _ in .init() }
        entity.color = Color.random.asHex
        entity.id = .init()
        entity.name = .someWord()
        entity.icon = RefdsIconSymbol.random.rawValue
        return entity
    }
}
