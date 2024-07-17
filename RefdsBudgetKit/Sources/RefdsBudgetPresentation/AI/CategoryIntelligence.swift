import SwiftUI
import CreateML
import CoreML
import TabularData
import RefdsBudgetDomain
import RefdsInjection

public protocol CategoryIntelligenceProtocol {
    func training()
    func predict(date: Date) -> UUID?
}

final class CategoryIntelligence: CategoryIntelligenceProtocol {
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    
    private var categoriesDict: [String: (CategoryEntity, Int)] = [:]
    private var model: MLBoostedTreeRegressor?
    
    init() {}
    
    private func getTrainingData() -> Data? {
        let categories = categoryRepository.getAllCategories()
        let transactions = Array(transactionRepository.getTransactions().reversed())
        
        var targetDict: [[String: Double]] = []
        
        guard categories.count > 3, transactions.count > 100 else { return nil }
        
        Dictionary(grouping: categories, by: { $0.id }).forEach { item in
            if let value = item.value.first,
               let position = categories.firstIndex(of: value) {
                categoriesDict[value.id.uuidString] = (value, position)
            }
        }
        
        for i in transactions.indices {
            if i + 1 < transactions.count {
                let transaction = transactions[i]
                if let nextTransaction = transactions[safe: i + 1],
                   let date = transactions[safe: i + 1]?.date,
                   let day = date.asString(withDateFormat: .day).asInt,
                   let hour = date.asString(withDateFormat: .custom("HH")).asInt,
                   let minute = date.asString(withDateFormat: .custom("mm")).asInt,
                   let category = categoriesDict[transaction.category.uuidString],
                   let target = categoriesDict[nextTransaction.category.uuidString] {
                    targetDict += [
                        [
                            "day": Double(day),
                            "hour": Double(hour),
                            "minute": Double(minute),
                            "category": Double(category.1),
                            "target": Double(target.1)
                        ]
                    ]
                }
            }
        }
        
        return try? JSONSerialization.data(withJSONObject: targetDict)
    }
    
    public func training() {
        guard model == nil,
              let jsonData = getTrainingData(),
              let data = try? DataFrame(jsonData: jsonData)
        else { return }
        
        let params = MLBoostedTreeRegressor.ModelParameters(
            validation: .none,
            maxDepth: 1_000,
            maxIterations: 1_000,
            minLossReduction: .zero,
            minChildWeight: 0.1,
            stepSize: 0.3,
            rowSubsample: 1,
            columnSubsample: 1
        )
        guard let model = try? MLBoostedTreeRegressor(
            trainingData: data,
            targetColumn: "target",
            parameters: params
        ) else { return  }
        
        let (_, testData) = data.randomSplit(by: 0.8)
        let evaluation = model.evaluation(on: DataFrame(testData))
        print(evaluation.rootMeanSquaredError, evaluation.maximumError)
        
        self.model = model
    }
    
    public func predict(date: Date) -> UUID? {
        training()
        var data: [String: Double] = [:]
        let transactions = Array(transactionRepository.getTransactions().reversed())
        let lastPosition = transactions.lastIndex(where: {
            $0.date.asString(withDateFormat: .dayMonthYear) == date.asString(withDateFormat: .dayMonthYear)
        }) ?? transactions.count - 1
        
        if let transaction = transactions[safe: lastPosition - 1] ?? transactions.last,
           let day = date.asString(withDateFormat: .day).asInt,
           let hour = date.asString(withDateFormat: .custom("HH")).asInt,
           let minute = date.asString(withDateFormat: .custom("mm")).asInt,
           let category = categoriesDict[transaction.category.uuidString] {
            data = [
                "day": Double(day),
                "hour": Double(hour),
                "minute": Double(minute),
                "category": Double(category.1)
            ]
        } else { return nil }
        
        guard let prediction = try? model?.model
            .prediction(from: CategoryIntelligenceInput(data: data))
            .featureValue(for: "target")?
            .doubleValue,
              let category = categoriesDict.values.first(where: { $0.1 == Int(prediction.rounded()) })?.0.id
        else { return nil }
        
        return category
    }
}
