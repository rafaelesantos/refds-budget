import Foundation
import RefdsRedux
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData

public extension RefdsReduxStore {
    static func mock(reducer: @escaping RefdsReduxReducer<State>, state: State) -> RefdsReduxStore<State> {
        RefdsContainer.register(type: RefdsBudgetDatabaseProtocol.self) { RefdsBudgetDatabaseMock() }
        RefdsContainer.register(type: CategoryUseCase.self) { LocalCategoryRepositoryMock() }
        RefdsContainer.register(type: TransactionUseCase.self) { LocalTransactionRepositoryMock() }
        RefdsContainer.register(type: SettingsUseCase.self) { LocalSettingsRepositoryMock() }
        RefdsContainer.register(type: BubbleUseCase.self) { LocalBubbleRepositoryMock() }
        RefdsContainer.register(type: CategoryAdapterProtocol.self) { CategoryAdapter() }
        RefdsContainer.register(type: TransactionAdapterProtocol.self) { TransactionAdapter() }
        
        return .init(
            reducer: reducer,
            state: state,
            middlewares: [
                CategoryMiddleware<State>().middleware
                //TransactionMiddleware<State>().middleware
            ]
        )
    }
}
