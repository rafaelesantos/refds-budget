import Foundation
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetPresentation

protocol RefdsBudgetWidgetPresenterProtocol {
    func getSystemSmallExpenseTrackerViewData(isFilterByDate: Bool) -> SystemSmallExpenseTrackerViewDataProtocol
}

final class RefdsBudgetWidgetPresenter: RefdsBudgetWidgetPresenterProtocol {
    private let categoryRepository: CategoryUseCase
    private let transactionsRepository: TransactionUseCase
    
    public init() {
        RefdsContainer.register(type: RefdsBudgetDatabaseProtocol.self) { RefdsBudgetDatabase() }
        categoryRepository = LocalCategoryRepository()
        transactionsRepository = LocalTransactionRepository()
    }
    
    func getSystemSmallExpenseTrackerViewData(isFilterByDate: Bool) -> SystemSmallExpenseTrackerViewDataProtocol {
        var spend: Double = .zero
        var budget: Double = .zero
        
        if isFilterByDate {
            spend = transactionsRepository.getTransactions(from: .current, format: .monthYear).map { $0.amount }.reduce(.zero, +)
            budget = categoryRepository.getBudgets(from: .current).map { $0.amount }.reduce(.zero, +)
        } else {
            spend = transactionsRepository.getTransactions().map { $0.amount }.reduce(.zero, +)
            budget = categoryRepository.getAllBudgets().map { $0.amount }.reduce(.zero, +)
        }
        
        return SystemSmallExpenseTrackerViewData(
            isFilterByDate: isFilterByDate,
            date: .current,
            spend: spend,
            budget: budget
        )
    }
}
