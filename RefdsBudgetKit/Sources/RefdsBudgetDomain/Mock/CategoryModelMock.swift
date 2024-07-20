import Foundation
import SwiftUI
import CoreData
import RefdsShared

public struct CategoryModelMock: CategoryModelProtocol {
    public var budgets: [UUID] = []
    public var color: String = Color.random.asHex
    public var id: UUID = .init()
    public var name: String = .someWord()
    public var icon: String = RefdsIconSymbol.random.rawValue
    
    public init() {}
    
    public func getEntity(for context: NSManagedObjectContext) -> CategoryEntity {
        CategoryEntity(model: self, for: context)
    }
}
