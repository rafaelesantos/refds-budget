import Foundation
import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class FilterMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var tagRepository: TagUseCase
    @RefdsInjection private var budgetRepository: BudgetUseCase
    @RefdsInjection private var categoryRepository: CategoryUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        switch action {
        case let action as TransactionsAction:
            self.handler(
                with: state.transactionsState,
                for: action,
                on: completion
            )
        case let action as HomeAction:
            self.handler(
                with: state.homeState,
                for: action,
                on: completion
            )
        default: break
        }
    }
    
    private func handler(
        with state: TransactionsStateProtocol,
        for action: TransactionsAction,
        on completion: @escaping (TransactionsAction) -> Void
    ) {
        switch action {
        case .fetchData:
            let items = getFilterItems(for: state.filter)
            completion(.updateFilterItems(items))
        default:
            break
        }
    }
    
    private func handler(
        with state: HomeStateProtocol,
        for action: HomeAction,
        on completion: @escaping (HomeAction) -> Void
    ) {
        switch action {
        case .fetchData:
            let items = getFilterItems(for: state.filter)
            completion(.updateFilterItems(items))
        default:
            break
        }
    }
    
    private func getFilterItems(for filter: FilterViewDataProtocol) -> [FilterItem] {
        var items = [FilterItem]()
        for item in filter.items {
            switch item {
            case .date:
                items += [.date]
            case .categories:
                let categories = getCategories(for: filter)
                items += [.categories(categories)]
            case .tags:
                let tags = getTags()
                items += [.tags(tags)]
            case .status:
                let status = getStatus()
                items += [.status(status)]
            }
        }
        return items
    }
    
    private func getCategories(for filter: FilterViewDataProtocol) -> [FilterRowViewDataProtocol] {
        let models = filter.isDateFilter ? categoryRepository.getCategories(from: filter.date) : categoryRepository.getAllCategories()
        return models.map { category in
            FilterRowViewData(
                id: category.id.uuidString,
                name: category.name,
                color: Color(hex: category.color),
                icon: RefdsIconSymbol(rawValue: category.icon)
            )
        }
    }
    
    private func getTags() -> [FilterRowViewDataProtocol] {
        tagRepository.getTags().map { tag in
            FilterRowViewData(
                id: tag.id.uuidString,
                name: tag.name,
                color: Color(hex: tag.color),
                icon: RefdsIconSymbol(rawValue: tag.icon)
            )
        }
    }
    
    private func getStatus() -> [FilterRowViewDataProtocol] {
        TransactionStatus.allCases.map { status in
            FilterRowViewData(
                id: status.rawValue,
                name: status.description,
                color: status.color,
                icon: status.icon
            )
        }
    }
}
