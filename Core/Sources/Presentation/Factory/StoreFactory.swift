import Foundation
import RefdsRedux
import RefdsInjection
import Domain
import Data
import Mock

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
        RefdsContainer.register(type: TransactionUseCase.self) { TransactionRepositoryMock() }
        RefdsContainer.register(type: BudgetUseCase.self) { BudgetRepositoryMock() }
        RefdsContainer.register(type: CategoryUseCase.self) { CategoryRepositoryMock() }
        RefdsContainer.register(type: SettingsUseCase.self) { SettingsRepositoryMock() }
        RefdsContainer.register(type: TagUseCase.self) { TagRepositoryMock() }
        registerAdapterDependencies()
        registerAIDependencies()
    }
    
    private static func registerProductionDependencies() {
        RefdsContainer.register(type: RefdsBudgetDatabaseProtocol.self) { RefdsBudgetDatabase() }
        RefdsContainer.register(type: TransactionUseCase.self) { TransactionRepository() }
        RefdsContainer.register(type: BudgetUseCase.self) { BudgetRepository() }
        RefdsContainer.register(type: CategoryUseCase.self) { CategoryRepository() }
        RefdsContainer.register(type: SettingsUseCase.self) { SettingsRepository() }
        RefdsContainer.register(type: TagUseCase.self) { TagRepository() }
        registerAdapterDependencies()
        registerAIDependencies()
    }
    
    private static func registerAdapterDependencies() {
        RefdsContainer.register(type: BudgetAdapterProtocol.self) { BudgetAdapter() }
        RefdsContainer.register(type: CategoryAdapterProtocol.self) { CategoryAdapter() }
        RefdsContainer.register(type: BudgetItemViewDataAdapterProtocol.self) { BudgetItemViewDataAdapter() }
        RefdsContainer.register(type: TransactionItemViewDataAdapterProtocol.self) { TransactionItemViewDataAdapter() }
        RefdsContainer.register(type: TagItemViewDataAdapterProtocol.self) { TagItemViewDataAdapter() }
        RefdsContainer.register(type: SettingsAdapterProtocol.self) { SettingsAdapter() }
    }
    
    private static func registerAIDependencies() {
        RefdsContainer.register(type: IntelligenceProtocol.self) { Intelligence() }
    }
    
    private static func getMiddlewares() -> [RefdsReduxMiddleware<ApplicationStateProtocol>] {
        [
            BalanceMiddleware<ApplicationStateProtocol>().middleware,
            FilterMiddleware<ApplicationStateProtocol>().middleware,
            AddBudgetMiddleware<ApplicationStateProtocol>().middleware,
            AddCategoryMiddleware<ApplicationStateProtocol>().middleware,
            CategoryMiddleware<ApplicationStateProtocol>().middleware,
            CategoriesMiddleware<ApplicationStateProtocol>().middleware,
            AddTransactionMiddleware<ApplicationStateProtocol>().middleware,
            TransactionsMiddleware<ApplicationStateProtocol>().middleware,
            TagMiddleware<ApplicationStateProtocol>().middleware,
            BudgetSelectionMiddleware<ApplicationStateProtocol>().middleware,
            BudgetComparisonMiddleware<ApplicationStateProtocol>().middleware,
            HomeMiddleware<ApplicationStateProtocol>().middleware,
            RouteMiddleware<ApplicationStateProtocol>().middleware,
            SettingsMiddleware<ApplicationStateProtocol>().middleware,
            ImportMiddleware<ApplicationStateProtocol>().middleware
        ]
    }
}
