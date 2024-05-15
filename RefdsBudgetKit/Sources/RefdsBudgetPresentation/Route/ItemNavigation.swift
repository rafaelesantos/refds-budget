import SwiftUI
import RefdsShared
import RefdsBudgetResource

public enum ItemNavigation: Int, Identifiable, CaseIterable {
    case premium = 0
    case categories = 1
    case home = 2
    case transactions = 3
    case settings = 4
    
    public var id: String {
        title
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
    
    public var title: String {
        switch self {
        case .premium: .localizable(by: .itemNavigationPremium)
        case .categories: .localizable(by: .itemNavigationCategories)
        case .home: .localizable(by: .itemNavigationHome)
        case .transactions: .localizable(by: .itemNavigationTransactions)
        case .settings: .localizable(by: .itemNavigationSettings)
        }
    }
    
    public func icon(isPro: Bool) -> RefdsIconSymbol {
        switch self {
        case .premium: return isPro ? .boltBadgeCheckmarkFill : .boltBadgeXmarkFill
        case .categories: return .squareStack3dForwardDottedlineFill
        case .home: return .houseFill
        case .transactions: return .listBulletRectangleFill
        case .settings: return .gear
        }
    }
}
