import Foundation
import SwiftUI
import RefdsShared
import CoreData

public class BubbleEntityMock {
    public static func value(for context: NSManagedObjectContext) -> BubbleEntity {
        let entity = BubbleEntity(context: context)
        entity.color = Color.random.asHex
        entity.id = .init()
        entity.name = .someWord()
        return entity
    }
}
