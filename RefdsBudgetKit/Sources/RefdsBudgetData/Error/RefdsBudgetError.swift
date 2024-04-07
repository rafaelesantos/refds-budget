import Foundation
import RefdsShared
import RefdsBudgetResource

public enum RefdsBudgetError: Error, RefdsAlert, RefdsModel {
    case existingCategory
    case notFoundCategory
    case notFoundBudget
    case existingTransaction
    case notFoundTransaction
    case cantDeleteCategory
    case cantDeleteBudget
    case existingBudget
    case cantSaveOnDatabase
    
    public var title: String? {
        switch self {
        case .existingCategory: return .localizable(by: .errorExistingCategoryTitle)
        case .notFoundCategory: return .localizable(by: .errorNotFoundCategoryTitle)
        case .notFoundBudget: return .localizable(by: .errorNotFoundBudgetTitle)
        case .existingTransaction: return .localizable(by: .errorExistingTransactionTitle)
        case .notFoundTransaction: return .localizable(by: .errorNotFoundTransactionTitle)
        case .cantDeleteCategory: return .localizable(by: .errorCantDeleteCategoryTitle)
        case .cantDeleteBudget: return .localizable(by: .errorCantDeleteBudgetTitle)
        case .existingBudget: return .localizable(by: .errorExistingBudgetTitle)
        case .cantSaveOnDatabase: return .localizable(by: .errorCantSaveOnDatabaseTitle)
        }
    }
    
    public var message: String? {
        switch self {
        case .existingCategory: return .localizable(by: .errorExistingCategoryDescription)
        case .notFoundCategory: return .localizable(by: .errorNotFoundCategoryDescription)
        case .notFoundBudget: return .localizable(by: .errorNotFoundBudgetDescription)
        case .existingTransaction: return .localizable(by: .errorExistingTransactionDescription)
        case .notFoundTransaction: return .localizable(by: .errorNotFoundTransactionDescription)
        case .cantDeleteCategory: return .localizable(by: .errorCantDeleteCategoryDescription)
        case .cantDeleteBudget: return .localizable(by: .errorCantDeleteBudgetDescription)
        case .existingBudget: return .localizable(by: .errorExistingBudgetDescription)
        case .cantSaveOnDatabase: return .localizable(by: .errorCantSaveOnDatabaseDescription)
        }
    }
}
