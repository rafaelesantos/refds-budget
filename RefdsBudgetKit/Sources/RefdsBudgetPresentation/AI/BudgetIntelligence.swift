import SwiftUI
import CreateML
import CoreML
import TabularData
import RefdsBudgetDomain
import RefdsInjection
import Accelerate

public protocol BudgetIntelligenceProtocol {
    func training()
    func predict(date: Date, category: UUID) -> Double?
}

final class BudgetIntelligence: BudgetIntelligenceProtocol {
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    
    private var categoriesDict: [String: (CategoryEntity, Int)] = [:]
    private var transactionsDict: [String: Double] = [:]
    private var model: MLBoostedTreeRegressor?
    
    init() {}
    
    private func getTrainingData() -> Data? {
        let categories = categoryRepository.getAllCategories()
        let transactions = transactionRepository.getTransactions()
        
        var targetDict: [[String: Double]] = []
        
        guard categories.count > 2, transactions.count > 20 else { return nil }
        
        Dictionary(grouping: categories, by: { $0.id }).forEach { item in
            if let value = item.value.first,
               let position = categories.firstIndex(of: value) {
                categoriesDict[value.id.uuidString] = (value, position)
            }
        }
        
        transactions.forEach { item in
            let date = item.date.date
            if let year = date.asString(withDateFormat: .year).asInt,
               let month = date.asString(withDateFormat: .custom("MM")).asInt {
                let currentValue = transactionsDict["\(item.category.uuidString)/\(year)/\(month)"] ?? .zero
                transactionsDict["\(item.category.uuidString)/\(year)/\(month)"] = item.amount + currentValue
            }
        }
        
        transactionsDict.forEach { item in
            let components = item.key.components(separatedBy: "/")
            if let categoryKey = components[safe: 0],
               let category = categoriesDict[categoryKey],
               let year = components[safe: 1]?.asInt,
               let month = components[safe: 2]?.asInt {
                let newYear = month == 12 ? year + 1 : year
                let newMonth = month == 12 ? 1 : month + 1
                let targetKey = "\(category.0.id.uuidString)/\(newYear)/\(newMonth)"
                if let target = transactionsDict[targetKey] {
                    targetDict += [
                        [
                            "year": Double(year),
                            "month": Double(month),
                            "category": Double(category.1),
                            "transactions": item.value,
                            "target": target
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
        
        self.model = model
    }
    
    public func predict(date: Date, category: UUID) -> Double? {
        training()
        let year = date.asString(withDateFormat: .year)
        let month = date.asString(withDateFormat: .custom("MM"))
        guard let category = categoriesDict[category.uuidString],
              let year = year.asInt,
              let month = month.asInt 
        else { return nil }
        
        let prevYear = month == 1 ? year - 1 : year
        let prevMonth = month == 1 ? 12 : month - 1
        let targetKey = "\(category.0.id.uuidString)/\(prevYear)/\(prevMonth)"
        let transactionsDict = transactionsDict.filter { element in
            element.key.contains(category.0.id.uuidString)
        }
        let last = transactionsDict.sorted { prev, next in
            let prevComponents = prev.key.components(separatedBy: "/")
            let nextComponents = next.key.components(separatedBy: "/")
            if let prevYear = prevComponents[safe: 1],
               let prevMonth = prevComponents[safe: 2],
               let nextYear = nextComponents[safe: 1],
               let nextMonth = nextComponents[safe: 2] {
                let prev = "\(prevYear)\(prevMonth)"
                let next = "\(nextYear)\(nextMonth)"
                return prev < next
            }
            return false
        }.map { $0.value }.last ?? .zero
        
        let data = [
            "year": Double(year),
            "month": Double(month),
            "category": Double(category.1),
            "transactions": transactionsDict[targetKey] ?? last
        ]
        
        guard let prediction = try? model?.model
            .prediction(from: BudgetIntelligenceInput(data: data))
            .featureValue(for: "target")
        else { return nil }
        
        return prediction.doubleValue
    }
}
