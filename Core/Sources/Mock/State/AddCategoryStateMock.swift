import SwiftUI
import RefdsShared
import Domain

public struct AddCategoryStateMock: AddCategoryStateProtocol {
    public var id: UUID = .init()
    public var name: String = .someWord()
    public var color: Color = .random
    public var icon: RefdsIconSymbol = .random
    public var showSaveButton: Bool = .random()
    public var error: RefdsBudgetError? = Bool.random() ? nil : .existingCategory
    public var canSave: Bool = true
    
    public init() {}
}
