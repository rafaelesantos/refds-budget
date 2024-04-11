import Foundation
import SwiftUI
import RefdsBudgetData

public struct AddCategoryStateMock: CategoryStateProtocol {
    public var id: UUID = .init()
    public var name: String = .someWord()
    public var color: Color = .random
    public var icon: String = "dollarsign"
    public var showSaveButton: Bool = .random()
    public var error: RefdsBudgetError? = Bool.random() ? nil : .existingCategory
    public var canSave: Bool = true
    
    public init() {}
}
