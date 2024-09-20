import Foundation
import RefdsShared
import Resource

public enum NavigationItem: Int, Identifiable, CaseIterable {
    case profile = 0
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
        case .profile: .localizable(by: .itemNavigationProfile)
        case .categories: .localizable(by: .itemNavigationCategories)
        case .home: .localizable(by: .itemNavigationHome)
        case .transactions: .localizable(by: .itemNavigationTransactions)
        case .settings: .localizable(by: .itemNavigationSettings)
        }
    }
    
    public func icon(isPro: Bool) -> RefdsIconSymbol {
        switch self {
        case .profile: return .personCropCircleFill
        case .categories: return .squareStack3dForwardDottedlineFill
        case .home: return .houseFill
        case .transactions: return .listBulletRectangleFill
        case .settings: return .gear
        }
    }
}
