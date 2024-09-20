import SwiftUI
import RefdsShared
import Domain

struct FilterItemViewData: FilterItemViewDataProtocol {
    var id: String
    var name: String
    var color: Color
    var icon: RefdsIconSymbol?
    
    init(
        id: String,
        name: String,
        color: Color,
        icon: RefdsIconSymbol?
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
    }
}
