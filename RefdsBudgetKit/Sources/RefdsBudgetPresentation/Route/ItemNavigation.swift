import SwiftUI
import RefdsShared
import RefdsBudgetResource

public enum ItemNavigation: Int, Identifiable, CaseIterable {
    case categories = 0
    case home = 1
    case transactions = 2
    case settings = 3
    
    public var id: String {
        title
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
    
    public var title: String {
        switch self {
        case .categories: .localizable(by: .itemNavigationCategories)
        case .home: .localizable(by: .itemNavigationHome)
        case .transactions: .localizable(by: .itemNavigationTransactions)
        case .settings: .localizable(by: .itemNavigationSettings)
        }
    }
    
    public var icon: RefdsIconSymbol {
        switch self {
        case .categories: return .squareStack3dForwardDottedlineFill
        case .home: return .houseFill
        case .transactions: return .listBulletRectangleFill
        case .settings: return .gear
        }
    }
}
