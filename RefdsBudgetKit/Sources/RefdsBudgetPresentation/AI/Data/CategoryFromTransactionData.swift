import Foundation
import RefdsBudgetDomain

public extension IntelligenceInput {
    static func categoryFromTransaction(
        date: Date,
        amount: Double
    ) -> IntelligenceInput? {
        var data: [String: Double] = [:]
        
        if let month = date.asString(withDateFormat: .custom("MM")).asInt,
           let day = date.asString(withDateFormat: .day).asInt,
           let hour = date.asString(withDateFormat: .custom("HH")).asInt,
           let minute = date.asString(withDateFormat: .custom("mm")).asInt {
            data = [
                "month": Double(month),
                "day": Double(day),
                "hour": Double(hour),
                "minute": Double(minute),
                "amount": amount
            ]
        } else { return nil }
        
        return IntelligenceInput(data: data)
    }
}

func CategoryFromTransactionData(
    categoryEntities: [CategoryModel],
    transactionEntities: [TransactionModel],
    on step: @escaping (String) -> Void
) -> Data? {
    var categoriesDict: [String: (CategoryModel, Int)] = [:]
    var targetDict: [[String: Double]] = []
    
    step(.localizable(by: .intelligenceTrainingGettingData))
    
    Dictionary(grouping: categoryEntities, by: { $0.id }).forEach { item in
        if let value = item.value.first,
           let position = categoryEntities.firstIndex(where: { $0.id == value.id }) {
            categoriesDict[value.id.uuidString] = (value, position)
        }
    }
    
    step(.localizable(by: .intelligenceTrainingPreparingData))
    
    for i in transactionEntities.indices {
        let transaction = transactionEntities[i]
           if let date = transactionEntities[safe: i + 1]?.date,
           let month = date.asString(withDateFormat: .custom("MM")).asInt,
           let day = date.asString(withDateFormat: .day).asInt,
           let hour = date.asString(withDateFormat: .custom("HH")).asInt,
           let minute = date.asString(withDateFormat: .custom("mm")).asInt,
           let target = categoriesDict[transaction.category.uuidString] {
            targetDict += [
                [
                    "month": Double(month),
                    "day": Double(day),
                    "hour": Double(hour),
                    "minute": Double(minute),
                    "amount": transaction.amount,
                    "target": Double(target.1)
                ]
            ]
        }
    }
    
    return try? JSONSerialization.data(withJSONObject: targetDict)
}
