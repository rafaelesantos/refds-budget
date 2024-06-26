import Foundation
import RefdsRedux
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData

public class StoreFactory {
    public static var development: RefdsReduxStore<ApplicationStateProtocol> {
        registerMockDependencies()
        return .init(
            reducer: ApplicationReducer().reduce,
            state: ApplicationStateMock(),
            middlewares: getMiddlewares()
        )
    }
    
    public static var production: RefdsReduxStore<ApplicationStateProtocol> {
        registerProductionDependencies()
        return .init(
            reducer: ApplicationReducer().reduce,
            state: ApplicationState(),
            middlewares: getMiddlewares()
        )
    }
    
    private static func registerMockDependencies() {
        RefdsContainer.register(type: RefdsBudgetDatabaseProtocol.self) { RefdsBudgetDatabaseMock() }
        RefdsContainer.register(type: CategoryUseCase.self) { LocalCategoryRepositoryMock() }
        RefdsContainer.register(type: TransactionUseCase.self) { LocalTransactionRepositoryMock() }
        RefdsContainer.register(type: SettingsUseCase.self) { LocalSettingsRepositoryMock() }
        RefdsContainer.register(type: BubbleUseCase.self) { LocalBubbleRepositoryMock() }
        registerAdapterDependencies()
    }
    
    private static func registerProductionDependencies() {
        RefdsContainer.register(type: RefdsBudgetDatabaseProtocol.self) { RefdsBudgetDatabase() }
        RefdsContainer.register(type: CategoryUseCase.self) { LocalCategoryRepository() }
        RefdsContainer.register(type: TransactionUseCase.self) { LocalTransactionRepository() }
        RefdsContainer.register(type: SettingsUseCase.self) { LocalSettingsRepository() }
        RefdsContainer.register(type: BubbleUseCase.self) { LocalBubbleRepository() }
        registerAdapterDependencies()
    }
    
    private static func registerAdapterDependencies() {
        RefdsContainer.register(type: BudgetAdapterProtocol.self) { BudgetAdapter() }
        RefdsContainer.register(type: CategoryAdapterProtocol.self) { CategoryAdapter() }
        RefdsContainer.register(type: BudgetRowViewDataAdapterProtocol.self) { BudgetRowViewDataAdapter() }
        RefdsContainer.register(type: TransactionRowViewDataAdapterProtocol.self) { TransactionRowViewDataAdapter() }
        RefdsContainer.register(type: TagRowViewDataAdapterProtocol.self) { TagRowViewDataAdapter() }
        RefdsContainer.register(type: SettingsAdapterProtocol.self) { SettingsAdapter() }
    }
    
    private static func getMiddlewares() -> [RefdsReduxMiddleware<ApplicationStateProtocol>] {
        [
            BalanceMiddleware<ApplicationStateProtocol>().middleware,
            AddBudgetMiddleware<ApplicationStateProtocol>().middleware,
            AddCategoryMiddleware<ApplicationStateProtocol>().middleware,
            CategoryMiddleware<ApplicationStateProtocol>().middleware,
            CategoriesMiddleware<ApplicationStateProtocol>().middleware,
            AddTransactionMiddleware<ApplicationStateProtocol>().middleware,
            TransactionsMiddleware<ApplicationStateProtocol>().middleware,
            TagMiddleware<ApplicationStateProtocol>().middleware,
            HomeMiddleware<ApplicationStateProtocol>().middleware,
            RouteMiddleware<ApplicationStateProtocol>().middleware,
            SettingsMiddleware<ApplicationStateProtocol>().middleware,
            StoreMiddleware<ApplicationStateProtocol>().middleware,
            ImportMiddleware<ApplicationStateProtocol>().middleware
        ]
    }
}
