import Foundation
import SwiftUI
import RefdsShared

public struct CategoryModelMock {
    public static var value: CategoryModel {
        CategoryModel(
            budgets: [],
            color: Color.random.asHex,
            id: .init(),
            name: .someWord(),
            icon: RefdsIconSymbol.random.rawValue
        )
    }
}
