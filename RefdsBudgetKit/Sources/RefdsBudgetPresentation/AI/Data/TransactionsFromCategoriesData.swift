import Foundation
import RefdsBudgetDomain

public extension IntelligenceInput {
    static func transactionsFromCategories(
        date: Date,
        category: String
    ) -> IntelligenceInput? {
        var data: [String: Any] = [:]
        
        if let month = date.asString(withDateFormat: .custom("MM")).asInt,
           let year = date.asString(withDateFormat: .year).asInt {
            data = [
                "month": Double(month),
                "year": Double(year),
                "category": category
            ]
        } else { return nil }
        
        return IntelligenceInput(data: data)
    }
}

func TransactionsFromCategoriesData(
    categories: [CategoryModelProtocol],
    transactionEntities: [TransactionModelProtocol],
    excludedDate: Date? = nil,
    on step: @escaping (String) -> Void
) -> Data? {
    var categoriesDict: [String: [TransactionModelProtocol]] = [:]
    var targetDict: [[String: Any]] = []
    
    step(.localizable(by: .intelligenceTrainingGettingData))
    
    let categoriesIndex = Dictionary(grouping: categories, by: { $0.id })
    
    for transaction in transactionEntities {
        if transaction.date.asString(withDateFormat: .monthYear) != excludedDate?.asString(withDateFormat: .monthYear),
           let category = categoriesIndex[transaction.category]?.first?.name {
            let year = transaction.date.asString(withDateFormat: .year)
            let month = transaction.date.asString(withDateFormat: .custom("MM"))
            categoriesDict["\(category)/\(year)/\(month)"] = (categoriesDict["\(category)/\(year)/\(month)"] ?? []) + [transaction]
        }
    }
    
    step(.localizable(by: .intelligenceTrainingPreparingData))
    
    for item in categoriesDict {
        let components = item.key.components(separatedBy: "/")
        if let category = components[safe: 0],
           let year = components[safe: 1]?.asInt,
           let month = components[safe: 2]?.asInt {
            targetDict += [
                [
                    "month": Double(month),
                    "year": Double(year),
                    "category": category,
                    "target": item.value.map { $0.amount }.reduce(.zero, +)
                ]
            ]
        }
    }
    
    return try? JSONSerialization.data(withJSONObject: targetDict)
}
