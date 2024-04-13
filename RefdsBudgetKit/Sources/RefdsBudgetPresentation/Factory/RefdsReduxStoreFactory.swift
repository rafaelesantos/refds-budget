import Foundation
import RefdsRedux
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData

public class RefdsReduxStoreFactory {
    public var mock: RefdsReduxStore<ApplicationStateProtocol> {
        .init(
            reducer: ApplicationReducer().reduce,
            state: ApplicationStateMock(),
            middlewares: getMiddlewares()
        )
    }
    
    public var production: RefdsReduxStore<ApplicationStateProtocol> {
        .init(
            reducer: ApplicationReducer().reduce,
            state: ApplicationState(),
            middlewares: getMiddlewares()
        )
    }
    
    public init(mock: Bool = false) {
        if mock { Self.registerMockDependencies() }
        else { Self.registerProductionDependencies() }
    }
    
    private static func registerMockDependencies() {
        RefdsContainer.register(type: RefdsBudgetDatabaseProtocol.self) { RefdsBudgetDatabaseMock() }
        RefdsContainer.register(type: CategoryUseCase.self) { LocalCategoryRepositoryMock() }
        RefdsContainer.register(type: TransactionUseCase.self) { LocalTransactionRepositoryMock() }
        RefdsContainer.register(type: SettingsUseCase.self) { LocalSettingsRepositoryMock() }
        RefdsContainer.register(type: BubbleUseCase.self) { LocalBubbleRepositoryMock() }
        RefdsContainer.register(type: BudgetAdapterProtocol.self) { BudgetAdapter() }
        RefdsContainer.register(type: CategoryAdapterProtocol.self) { CategoryAdapter() }
        RefdsContainer.register(type: TransactionAdapterProtocol.self) { TransactionAdapter() }
    }
    
    private static func registerProductionDependencies() {
        RefdsContainer.register(type: RefdsBudgetDatabaseProtocol.self) { RefdsBudgetDatabase() }
        RefdsContainer.register(type: CategoryUseCase.self) { LocalCategoryRepository() }
        RefdsContainer.register(type: TransactionUseCase.self) { LocalTransactionRepository() }
        RefdsContainer.register(type: SettingsUseCase.self) { LocalSettingsRepository() }
        RefdsContainer.register(type: BubbleUseCase.self) { LocalBubbleRepository() }
        RefdsContainer.register(type: BudgetAdapterProtocol.self) { BudgetAdapter() }
        RefdsContainer.register(type: CategoryAdapterProtocol.self) { CategoryAdapter() }
        RefdsContainer.register(type: TransactionAdapterProtocol.self) { TransactionAdapter() }
    }
    
    private func getMiddlewares() -> [RefdsReduxMiddleware<ApplicationStateProtocol>] {
        [
            AddBudgetMiddleware<ApplicationStateProtocol>().middleware,
            AddCategoryMiddleware<ApplicationStateProtocol>().middleware,
            CategoriesMiddleware<ApplicationStateProtocol>().middleware,
            TransactionMiddleware<ApplicationStateProtocol>().middleware,
            BalanceMiddleware().middleware,
            RouteMiddleware<ApplicationStateProtocol>().middleware,
        ]
    }
}
