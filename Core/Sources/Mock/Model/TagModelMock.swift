import SwiftUI
import CoreData
import RefdsShared
import Domain

public struct TagModelMock: TagModelProtocol {
    public var color: String = Color.random.asHex
    public var id: UUID = .init()
    public var name: String = .someWord()
    public var icon: String = RefdsIconSymbol.random.rawValue
    
    public init() {}
    
    public func getEntity(for context: NSManagedObjectContext) -> BubbleEntity {
        BubbleEntity(model: self, for: context)
    }
}
