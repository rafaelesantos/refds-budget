import SwiftUI
import RefdsShared
import Domain

struct AddCategoryState: AddCategoryStateProtocol {
    var id: UUID
    var name: String
    var color: Color
    var icon: RefdsIconSymbol
    var error: RefdsBudgetError?
    
    var canSave: Bool {
        name.count > 2
    }
    
    init(
        id: UUID = .init(),
        name: String = "",
        color: Color = .accentColor,
        icon: String = RefdsIconSymbol.dollarsign.rawValue
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = RefdsIconSymbol(rawValue: icon) ?? .dollarsign
    }
}
