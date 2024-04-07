import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class CategoryMiddleware: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var repository: CategoryUseCase
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<any RefdsReduxState> = { state, action, completion in
        self.handler(with: state as? AddBudgetStateProtocol, for: action as? AddBudgetAction, on: completion)
        self.handler(with: state as? AddCategoryStateProtocol, for: action as? AddCategoryAction, on: completion)
    }
    
    private func handler(
        with state: AddBudgetStateProtocol?,
        for addBudgetAction: AddBudgetAction?,
        on completion: RefdsReduxMiddlewareCompletion
    ) {
        guard let state = state else {
            return completion(AddBudgetAction.updateError(.cantSaveOnDatabase))
        }
        
        switch addBudgetAction {
        case .save:
            do {
                try repository.addBudget(
                    id: state.id,
                    amount: state.amount,
                    date: state.month,
                    message: state.description,
                    category: state.categoryId
                )
            } catch {
                return completion(AddBudgetAction.updateError(.existingBudget))
            }
            
            guard let category = repository.getCategory(by: state.categoryId) else {
                return completion(AddBudgetAction.updateError(.notFoundCategory))
            }
            
            do {
                try repository.addCategory(
                    id: category.id,
                    name: category.name,
                    color: Color(hex: category.color),
                    budgets: category.budgets + [state.id],
                    icon: category.icon
                )
            } catch {
                return completion(AddBudgetAction.updateError(.existingCategory))
            }
            
            completion(AddBudgetAction.dismiss)
        default:
            break
        }
    }
    
    private func handler(
        with state: AddCategoryStateProtocol?,
        for addCategoryAction: AddCategoryAction?,
        on completion: RefdsReduxMiddlewareCompletion
    ) {
        guard let state = state else {
            return completion(AddCategoryAction.updateError(.cantSaveOnDatabase))
        }
        
        switch addCategoryAction {
        case .save:
            do {
                try repository.addCategory(
                    id: state.id,
                    name: state.name,
                    color: state.color,
                    budgets: state.budgets.map { $0.id },
                    icon: state.icon
                )
            } catch {
                return completion(AddCategoryAction.updateError(.existingCategory))
            }
            
            completion(AddCategoryAction.dismiss)
        default:
            break
        }
    }
}
