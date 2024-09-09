import SwiftUI
import CreateML
import CoreML
import RefdsShared
import TabularData
import RefdsShared
import RefdsBudgetDomain
import RefdsInjection

public protocol IntelligenceProtocol {
    func training(
        model: IntelligenceModel,
        for level: IntelligenceLevel,
        on step: @escaping (String, IntelligenceModel, IntelligenceLevel) -> Void
    )
    
    func training(
        model: IntelligenceModel,
        on step: @escaping (String, IntelligenceModel, IntelligenceLevel) -> Void
    )
    
    func training(
        for level: IntelligenceLevel,
        with excludeDate: Date?,
        on step: @escaping (String, IntelligenceModel, IntelligenceLevel) -> Void
    )
    
    func training(
        with excludeDate: Date?,
        on step: @escaping (String, IntelligenceModel, IntelligenceLevel) -> Void
    )
    
    func predict(
        for input: IntelligenceInput?,
        with model: IntelligenceModel,
        on level: IntelligenceLevel
    ) -> Double?
    
    func updateDefaultBase()
}

final class Intelligence: IntelligenceProtocol {
    private var tagEntities: [TagModelProtocol] = []
    private var budgetEntities: [BudgetModelProtocol] = []
    private var categoryEntities: [CategoryModelProtocol] = []
    private var transactionEntities: [TransactionModelProtocol] = []
    
    private let group = DispatchGroup()
    private let queue = DispatchQueue(
        label: "refds.budget.intelligence",
        qos: .utility,
        attributes: .concurrent
    )
    
    init() {}
    
    private typealias ExecuteItem = () -> Void
    private func execute(items: [ExecuteItem]) {
        items.forEach { item in
            group.enter()
            queue.async {
                item()
                self.group.leave()
            }
        }
        group.wait()
    }
    
    private func setupDefaultBase() {
        if !budgetEntities.isEmpty,
           !categoryEntities.isEmpty,
           !transactionEntities.isEmpty { return }
        
        execute(
            items: [
                { self.tagEntities = IntelligenceInput.tagEntities },
                { self.budgetEntities = IntelligenceInput.budgetEntities },
                { self.categoryEntities = IntelligenceInput.categoryEntities },
                { self.transactionEntities = IntelligenceInput.transactionEntities }
            ]
        )
    }
    
    private func trainingModelItem(
        model: IntelligenceModel,
        for level: IntelligenceLevel,
        on step: @escaping (String, IntelligenceModel, IntelligenceLevel) -> Void
    ) {
        guard let jsonData = model.getData(
            tagEntities: tagEntities,
            budgetEntities: budgetEntities,
            categoryEntities: categoryEntities,
            transactionEntities: transactionEntities,
            on: { step($0, model, level) }
        ),
              let data = try? DataFrame(jsonData: jsonData)
        else { return }
        
        step(.localizable(by: .intelligenceTrainingTrainingData), model, level)
        
        guard let regressor = try? MLBoostedTreeRegressor(
            trainingData: data,
            targetColumn: "target",
            parameters: level.params
        ) else { return }
        
        let testData = DataFrame(data.randomSplit(by: 0.5).1)
        let evaluation = regressor.evaluation(on: testData)
        let message = """
        \(model.key(for: level))
        "Root Mean Square Error: \(evaluation.rootMeanSquaredError.rounded(toPlaces: 3) * 100)%"
        "Maximum Error: \(evaluation.maximumError.rounded(toPlaces: 3))"
        """
        RefdsLoggerSystem.shared.info(message: message)
        
        step(.localizable(by: .intelligenceTrainingSavingData), model, level)
        
        model.save(regressor, for: level)
    }
    
    func training(
        model: IntelligenceModel,
        for level: IntelligenceLevel,
        on step: @escaping (String, IntelligenceModel, IntelligenceLevel) -> Void
    ) {
        setupDefaultBase()
        execute(items: [{
            self.trainingModelItem(
                model: model,
                for: level,
                on: step
            )
        }])
    }
    
    func training(
        model: IntelligenceModel,
        on step: @escaping (String, IntelligenceModel, IntelligenceLevel) -> Void
    ) {
        setupDefaultBase()
        execute(items: IntelligenceLevel.allCases.map { level in
            {
                self.trainingModelItem(
                    model: model,
                    for: level,
                    on: step
                )
            }
        })
    }
    
    func training(
        for level: IntelligenceLevel,
        with excludeDate: Date?,
        on step: @escaping (String, IntelligenceModel, IntelligenceLevel) -> Void
    ) {
        setupDefaultBase()
        execute(items: IntelligenceModel.allCases(for: excludeDate).map { model in
            {
                self.trainingModelItem(
                    model: model,
                    for: level,
                    on: step
                )
            }
        })
    }
    
    func training(
        with excludeDate: Date?,
        on step: @escaping (String, IntelligenceModel, IntelligenceLevel) -> Void
    ) {
        setupDefaultBase()
        let items = IntelligenceModel.allCases(for: excludeDate).map { model in
            IntelligenceLevel.allCases.map { level in
                {
                    self.trainingModelItem(
                        model: model,
                        for: level,
                        on: step
                    )
                }
            }
        }.flatMap { $0 }
        execute(items: items)
    }
    
    func predict(
        for input: IntelligenceInput?,
        with model: IntelligenceModel,
        on level: IntelligenceLevel
    ) -> Double? {
        guard let input = input else { return nil }
        
        guard let model = model.model(for: level) else {
            training(model: model, for: level, on: { _, _, _ in })
            guard let model = model.model(for: level) else { return nil }
            return try? model.prediction(from: input).featureValue(for: input.targetKey)?.doubleValue
        }
        
        return try? model.prediction(from: input).featureValue(for: input.targetKey)?.doubleValue
    }
    
    func updateDefaultBase() {
        budgetEntities = []
        categoryEntities = []
        transactionEntities = []
        resetCustomLevel()
    }
    
    private func resetCustomLevel() {
        IntelligenceModel.allCases.forEach { model in
            model.delete(for: .custom)
        }
    }
}
