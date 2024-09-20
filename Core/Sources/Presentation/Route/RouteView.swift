import Foundation
import Domain

public enum RouteView: String {
    case addBudget = "/add-budget"
    case addCategory = "/add-category"
    case category = "/category"
    case addTransaction = "/add-transaction"
    case manageTags = "/manage-tags"
    case budgetSelection = "/budget-selection"
    case budgetComparison = "/budget-comparison"
    case importData = "/import-data"
    case dismiss = "/dismiss"
    case none = "/"
    
    public var route: ApplicationRouteItem? {
        switch self {
        case .addBudget: return .addBudget
        case .addCategory: return .addCategory
        case .addTransaction: return .addTransaction
        case .category: return .category
        case .manageTags: return .manageTags
        case .budgetSelection: return .budgetSelection
        case .budgetComparison: return .budgetComparison
        case .importData: return .import
        case .none, .dismiss: return nil
        }
    }
}
