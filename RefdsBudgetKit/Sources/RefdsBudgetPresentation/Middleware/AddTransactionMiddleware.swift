import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource
import WidgetKit

public final class AddTransactionMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var tagRepository: TagUseCase
    @RefdsInjection private var budgetRepository: BudgetUseCase
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    @RefdsInjection private var categoryAdapter: CategoryAdapterProtocol
    @RefdsInjection private var tagRowViewDataAdapter: TagRowViewDataAdapterProtocol
    @RefdsInjection private var intelligence: IntelligenceProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = (state as? ApplicationStateProtocol)?.addTransactionState else { return }
        switch action {
        case let action as AddTransactionAction: self.handler(with: state, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: AddTransactionStateProtocol,
        for addTransactionAction: AddTransactionAction,
        on completion: @escaping (AddTransactionAction) -> Void
    ) {
        switch addTransactionAction {
        case let .fetchCategories(date, amount): fetchCategories(
            from: date,
            amount: amount,
            on: completion
        )
        case let .fetchTags(description): fetchTags(
            for: description,
            on: completion
        )
        case let .save(amount, description): save(
            with: state,
            amount: amount,
            description: description,
            on: completion
        )
        default: break
        }
    }
    
    private func fetchCategories(
        from date: Date,
        amount: Double,
        on completion: @escaping (AddTransactionAction) -> Void
    ) {
        let allCategories = categoryRepository.getAllCategories()
        var categoriesDict: [String: (CategoryModelProtocol, Int)] = [:]
        
        Dictionary(grouping: allCategories, by: { $0.id }).forEach { item in
            if let value = item.value.first,
               let position = allCategories.firstIndex(where: { $0.id == value.id }) {
                categoriesDict[value.id.uuidString] = (value, position)
            }
        }
        
        let categories: [CategoryRowViewDataProtocol] = categoryRepository.getCategories(from: date).compactMap {
            guard let budget = budgetRepository.getBudget(on: $0.id, from: date) else { return nil }
            let transactions = transactionRepository.getTransactions(on: $0.id, from: date, format: .monthYear).filter {
                let status = TransactionStatus(rawValue: $0.status)
                return status != .pending && status != .cleared
            }
            let spend = transactions.map { $0.amount }.reduce(.zero, +)
            let percentage = spend / (budget.amount == .zero ? 1 : budget.amount)
            return categoryAdapter.adapt(
                model: $0,
                budgetDescription: budget.message,
                budget: budget.amount,
                percentage: percentage,
                transactionsAmount: transactions.count,
                spend: spend
            )
        }
        
        if let position = intelligence.predict(
            for: .categoryFromTransactions(date: date, amount: amount),
            with: .categoryFromTransactions,
            on: .high
        )?.rounded(),
           let categoryId = categoriesDict.first(where: { $0.value.1 == Int(position) })?.value.0.id,
           let category = categories.first(where: { $0.id == categoryId }),
           amount > .zero {
            completion(.updateCategories(category, categories))
        } else {
            completion(.updateCategories(nil, categories))
        }
    }
    
    private func save(
        with state: AddTransactionStateProtocol,
        amount: Double,
        description: String,
        on completion: @escaping (AddTransactionAction) -> Void
    ) {
        guard let category = state.category else {
            return completion(.updateError(.notFoundCategory))
        }
        
        do {
            try transactionRepository.addTransaction(
                id: state.id,
                date: state.date,
                message: description,
                category: category.id,
                amount: amount,
                status: state.status
            )
            WidgetCenter.shared.reloadAllTimelines()
            completion(.dismiss)
        } catch {
            completion(.updateError(.existingTransaction))
        }
    }
    
    private func fetchTags(
        for description: String,
        on completion: @escaping (AddTransactionAction) -> Void
    ) {
        let tagModels = tagRepository.getTags()
        
        guard !description.isEmpty else { return }
        
        let description = description.lowercased()
        let tagAdapteds = tagModels.filter {
            description.contains($0.name.lowercased())
        }.map {
            tagRowViewDataAdapter.adapt(
                model: $0,
                value: nil,
                amount: nil
            )
        }
        completion(.updateTags(tagAdapteds))
    }
}
