import Foundation
import Domain

public extension IntelligenceInput {
    static func transactionsFromTags(
        date: Date,
        tag: String
    ) -> IntelligenceInput? {
        var data: [String: Any] = [:]
        
        if let month = date.asString(withDateFormat: .custom("MM")).asInt,
           let year = date.asString(withDateFormat: .year).asInt {
            data = [
                "month": Double(month),
                "year": Double(year),
                "tag": tag
            ]
        } else { return nil }
        
        return IntelligenceInput(data: data)
    }
}

func TransactionsFromTagsData(
    tagEntities: [TagModelProtocol],
    transactionEntities: [TransactionModelProtocol],
    excludedDate: Date? = nil,
    on step: @escaping (String) -> Void
) -> Data? {
    var tagsDict: [String: [TransactionModelProtocol]] = [:]
    var targetDict: [[String: Any]] = []
    
    step(.localizable(by: .intelligenceTrainingGettingData))
    
    for transaction in transactionEntities {
        for tag in tagEntities {
            if transaction.date.asString(withDateFormat: .monthYear) != excludedDate?.asString(withDateFormat: .monthYear),
               transaction.message
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
