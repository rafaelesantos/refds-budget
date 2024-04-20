import Foundation
import RefdsShared
import RefdsBudgetResource

public enum RefdsBudgetError: Error, RefdsAlert, RefdsModel {
    case existingCategory
    case existingTransaction
    case existingBudget
    case existingTag
    case cantDeleteCategory
    case cantDeleteBudget
    case cantDeleteTag
    case cantSaveOnDatabase
    case notFoundCategory
    case notFoundBudget
    case notFoundTag
    case notFoundTransaction
    
    public var title: String? {
        switch self {
        case .existingBudget: return .localizable(by: .errorExistingBudgetTitle)
        case .existingCategory: return .localizable(by: .errorExistingCategoryTitle)
        case .existingTransaction: return .localizable(by: .errorExistingTransactionTitle)
        case .existingTag: return .localizable(by: .errorExistingTagTitle)
        case .notFoundCategory: return .localizable(by: .errorNotFoundCategoryTitle)
        case .notFoundBudget: return .localizable(by: .errorNotFoundBudgetTitle)
        case .notFoundTransaction: return .localizable(by: .errorNotFoundTransactionTitle)
        case .notFoundTag: return .localizable(by: .errorNotFoundTagTitle)
        case .cantDeleteCategory: return .localizable(by: .errorCantDeleteCategoryTitle)
        case .cantDeleteBudget: return .localizable(by: .errorCantDeleteBudgetTitle)
        case .cantDeleteTag: return .localizable(by: .errorCantDeleteTagTitle)
        case .cantSaveOnDatabase: return .localizable(by: .errorCantSaveOnDatabaseTitle)
        }
    }
    
    public var message: String? {
        switch self {
        case .existingBudget: return .localizable(by: .errorExistingBudgetDescription)
        case .existingCategory: return .localizable(by: .errorExistingCategoryDescription)
        case .existingTransaction: return .localizable(by: .errorExistingTransactionDescription)
        case .existingTag: return .localizable(by: .errorExistingTagDescription)
        case .notFoundCategory: return .localizable(by: .errorNotFoundCategoryDescription)
        case .notFoundBudget: return .localizable(by: .errorNotFoundBudgetDescription)
        case .notFoundTransaction: return .localizable(by: .errorNotFoundTransactionDescription)
        case .notFoundTag: return .localizable(by: .errorNotFoundTagDescription)
        case .cantDeleteCategory: return .localizable(by: .errorCantDeleteCategoryDescription)
        case .cantDeleteBudget: return .localizable(by: .errorCantDeleteBudgetDescription)
        case .cantDeleteTag: return .localizable(by: .errorCantDeleteTagDescription)
        case .cantSaveOnDatabase: return .localizable(by: .errorCantSaveOnDatabaseDescription)
        }
    }
}
