import SwiftUI

public protocol ViewFactoryProtocol {
    func makeAddBudgetView(
        state: Binding<AddBudgetStateProtocol>,
        action: @escaping (AddBudgetAction) -> Void
    ) -> any View
    
    func makeAddCategoryView(
        state: Binding<AddCategoryStateProtocol>,
        action: @escaping (AddCategoryAction) -> Void
    ) -> any View
    
    func makeCategoryView(
        state: Binding<CategoryStateProtocol>,
        action: @escaping (CategoryAction) -> Void
    ) -> any View
    
    func makeCategoriesView(
        state: Binding<CategoriesStateProtocol>,
        action: @escaping (CategoriesAction) -> Void
    ) -> any View
    
    func makeAddTransactionView(
        state: Binding<AddTransactionStateProtocol>,
        action: @escaping (AddTransactionAction) -> Void
    ) -> any View
    
    func makeTransactionsView(
        state: Binding<TransactionsStateProtocol>,
        action: @escaping (TransactionsAction) -> Void
    ) -> any View
    
    func makeTagView(
        state: Binding<TagsStateProtocol>,
        action: @escaping (TagAction) -> Void
    ) -> any View
    
    func makeHomeView(
        state: Binding<HomeStateProtocol>,
        action: @escaping (HomeAction) -> Void
    ) -> any View
    
    func makeSettingsView(
        state: Binding<SettingsStateProtocol>,
        action: @escaping (SettingsAction) -> Void
    ) -> any View
    
    func makeImportView(
        state: Binding<ImportStateProtocol?>,
        action: @escaping (ImportAction) -> Void
    ) -> any View
    
    func makeBudgetSelectionView(
        state: Binding<BudgetSelectionStateProtocol>,
        action: @escaping (BudgetSelectionAction) -> Void
    ) -> any View
    
    func makeBudgetComparisonView(
        state: Binding<BudgetComparisonStateProtocol>,
        action: @escaping (BudgetComparisonAction) -> Void
    ) -> any View
}
