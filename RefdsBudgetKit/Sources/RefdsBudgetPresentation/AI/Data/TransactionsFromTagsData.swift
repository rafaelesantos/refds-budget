import Foundation
import RefdsBudgetDomain

public extension IntelligenceInput {
    static func transactionsFromTags(
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

func TransactionsFromTagsData(
    tagEntities: [TagModelProtocol],
    transactionEntities: [TransactionModelProtocol],
    on step: @escaping (String) -> Void
) -> Data? {
    var tagsDict: [String: [TransactionModelProtocol]] = [:]
    var targetDict: [[String: Any]] = []
    
    step(.localizable(by: .intelligenceTrainingGettingData))
    
    for transaction in transactionEntities {
        for tag in tagEntities {
            if transaction.message
                .folding(options: .diacriticInsensitive, locale: .current)
                .lowercased()
                .contains(
                    tag.name
                        .folding(options: .diacriticInsensitive, locale: .current)
                        .lowercased()
                ) {
                let year = transaction.date.asString(withDateFormat: .year)
                let month = transaction.date.asString(withDateFormat: .custom("MM"))
                tagsDict["\(tag.name)/\(year)/\(month)"] = (tagsDict["\(tag.name)/\(year)/\(month)"] ?? []) + [transaction]
            }
        }
    }
    
    step(.localizable(by: .intelligenceTrainingPreparingData))
    
    for item in tagsDict {
        let components = item.key.components(separatedBy: "/")
        if let tag = components[safe: 0],
           let year = components[safe: 1]?.asInt,
           let month = components[safe: 2]?.asInt {
            targetDict += [
                [
                    "month": Double(month),
                    "year": Double(year),
                    "tag": tag,
                    "target": item.value.map { $0.amount }.reduce(.zero, +)
                ]
            ]
        }
    }
    
    return try? JSONSerialization.data(withJSONObject: targetDict)
}
