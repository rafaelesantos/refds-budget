import Foundation
import SwiftUI
import WidgetKit
import RefdsRedux
import RefdsShared
import RefdsInjection
import Domain
import Resource

public final class AddCategoryMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var budgetRepository: BudgetUseCase
    @RefdsInjection private var categoryRepository: CategoryUseCase
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        switch action {
        case let action as AddCategoryAction:
            self.handler(
                with: state.addCategoryState,
                for: action,
                on: completion
            )
        default: break
        }
    }
    
    private func handler(
        with state: AddCategoryStateProtocol,
        for action: AddCategoryAction,
        on completion: @escaping (AddCategoryAction) -> Void
    ) {
        switch action {
        case .fetchData:
            fetchData(
                with: state.id,
                on: completion
            )
        case .save:
            save(
                with: state,
                on: completion
            )
        default:
            break
        }
    }
    
    private func fetchData(
        with id: UUID,
        on completion: @escaping (AddCategoryAction) -> Void
    ) {
        guard let category = categoryRepository.getCategory(by: id) else {
            return completion(
                .updateData(
                    id: .init(),
                    name: "",
                    color: .random,
                    icon: RefdsIconSymbol.categoryIcons.randomElement() ?? .dollarsign
                )
            )
        }
        completion(
            .updateData(
                id: category.id,
                name: category.name,
                color: Color(hex: category.color),
                icon: RefdsIconSymbol(rawValue: category.icon) ?? .dollarsign
            )
        )
    }
    
    private func save(
        with state: AddCategoryStateProtocol,
        on completion: @escaping (AddCategoryAction) -> Void
    ) {
        let budgets = budgetRepository.getBudgets(on: state.id)
        let categories = categoryRepository.getAllCategories()
        
        if categories.contains(where: {
                  $0.name.folding(options: .diacriticInsensitive, locale: .current).lowercased() ==
            state.name.folding(options: .diacriticInsensitive, locale: .current).lowercased()
        }), categoryRepository.getCategory(by: state.id) == nil {
            return completion(.updateError(.existingCategory))
        }
        
        do {
            try categoryRepository.addCategory(
                id: state.id,
                name: state.name,
                color: state.color,
                budgets: budgets.map { $0.id },
                icon: state.icon.rawValue
            )
        } catch {
            return completion(.updateError(.existingCategory))
        }
        
        WidgetCenter.shared.reloadAllTimelines()
        let router = RefdsContainer.resolve(type: ApplicationRouterActionProtocol.self)
        router.to(scene: .current, view: .dismiss, viewStates: [])
    }
}
