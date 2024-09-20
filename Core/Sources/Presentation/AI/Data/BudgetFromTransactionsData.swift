import Foundation
import Domain

public extension IntelligenceInput {
    static func budgetFromTransactions(
        date: Date,
        category: UUID
    ) -> IntelligenceInput? {
        var categoriesDict: [String: (CategoryModelProtocol, Int)] = [:]
        
        let categoryEntities = categoryEntities
        let year = date.asString(withDateFormat: .year)
        let month = date.asString(withDateFormat: .custom("MM"))
        
        Dictionary(grouping: categoryEntities, by: { $0.id }).forEach { item in
            if let value = item.value.first,
               let position = categoryEntities.firstIndex(where: { $0.id == value.id }) {
                categoriesDict[value.id.uuidString] = (value, position)
            }
        }
        
        guard let category = categoriesDict[category.uuidString],
              let year = year.asInt,
              let month = month.asInt
        else { return nil }
        
        let data = [
            "year": Double(year),
            "month": Double(month),
            "category": Double(category.1)
        ]
        
        return IntelligenceInput(data: data)
    }
}

func BudgetFromTransactionsData(
    categoryEntities: [CategoryModelProtocol],
    transactionEntities: [TransactionModelProtocol],
    excludedDate: Date? = nil,
    on step: @escaping (String) -> Void
) -> Data? {
    var categoriesDict: [String: (CategoryModelProtocol, Int)] = [:]
    var transactionsDict: [String: Double] = [:]
    var targetDict: [[String: Double]] = []
    
    step(.localizable(by: .intelligenceTrainingGettingData))
    
    Dictionary(grouping: categoryEntities, by: { $0.id }).forEach { item in
        if let value = item.value.first,
           let position = categoryEntities.firstIndex(where: { $0.id == value.id }) {
            categoriesDict[value.id.uuidString] = (value, position)
        }
    }
    
    transactionEntities.forEach { item in
        let date = item.date.date
        if date.asString(withDateFormat: .monthYear) != excludedDate?.asString(withDateFormat: .monthYear),
           let year = date.asString(withDateFormat: .year).asInt,
           let month = date.asString(withDateFormat: .custom("MM")).asInt {
            let currentValue = transactionsDict["\(item.category.uuidString)/\(year)/\(month)"] ?? .zero
            transactionsDict["\(item.category.uuidString)/\(year)/\(month)"] = item.amount + currentValue
        }
    }
    
    step(.localizable(by: .intelligenceTrainingPreparingData))
    
    transactionsDict.forEach { item in
        let components = item.key.components(separatedBy: "/")
        if let categoryKey = components[safe: 0],
           let category = categoriesDict[categoryKey],
           let year = components[safe: 1]?.asInt,
           let month = components[safe: 2]?.asInt {
            targetDict += [
                [
                    "year": Double(year),
                    "month": Double(month),
                    "category": Double(category.1),
                    "target": item.value
                ]
            ]
        }
    }
    
    return try? JSONSerialization.data(withJSONObject: targetDict)
}
