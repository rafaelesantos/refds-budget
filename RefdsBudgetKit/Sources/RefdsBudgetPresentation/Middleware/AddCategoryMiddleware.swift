import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetResource

public final class AddCategoryMiddleware<State>: RefdsReduxMiddlewareProtocol {
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
        with state: CategoryStateProtocol,
        on completion: @escaping (AddCategoryAction) -> Void
    ) {
        guard let entity = categoryRepository.getCategory(by: state.id) else {
            return completion(.updateCategroy(state))
        }
        let adapted = categoryAdapter.adapt(entity: entity)
        completion(.updateCategroy(adapted))
    }
    
    private func save(
        _ category: CategoryStateProtocol,
        on completion: @escaping (AddCategoryAction) -> Void
    ) {
        let budgets = categoryRepository.getBudgets(on: category.id)
        
        do {
            try categoryRepository.addCategory(
                id: category.id,
                name: category.name,
                color: category.color,
                budgets: budgets.map { $0.id },
                icon: category.icon
            )
        } catch { return completion(.updateError(.existingCategory))}
        
        completion(.dismiss)
    }
}
