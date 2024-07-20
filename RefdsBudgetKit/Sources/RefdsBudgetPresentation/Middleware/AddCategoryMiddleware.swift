import Foundation
import SwiftUI
import WidgetKit
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class AddCategoryMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var budgetRepository: BudgetUseCase
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var categoryAdapter: CategoryAdapterProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { _, action, completion in
        switch action {
        case let action as AddCategoryAction: self.handler(for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        for action: AddCategoryAction,
        on completion: @escaping (AddCategoryAction) -> Void
    ) {
        switch action {
        case let .fetchCategory(state): fetchCategory(with: state, on: completion)
        case let .save(category): save(category, on: completion)
        default:
            break
        }
    }
    
    private func fetchCategory(
        with state: AddCategoryStateProtocol,
        on completion: @escaping (AddCategoryAction) -> Void
    ) {
        guard let model = categoryRepository.getCategory(by: state.id) else {
            return completion(.updateCategroy(state))
        }
        let adapted = categoryAdapter.adapt(model: model)
        completion(.updateCategroy(adapted))
    }
    
    private func save(
        _ category: AddCategoryStateProtocol,
        on completion: @escaping (AddCategoryAction) -> Void
    ) {
        let budgets = budgetRepository.getBudgets(on: category.id)
        
        do {
            try categoryRepository.addCategory(
                id: category.id,
                name: category.name,
                color: category.color,
                budgets: budgets.map { $0.id },
                icon: category.icon.rawValue
            )
        } catch { return completion(.updateError(.existingCategory))}
        WidgetCenter.shared.reloadAllTimelines()
        completion(.dismiss)
    }
}
