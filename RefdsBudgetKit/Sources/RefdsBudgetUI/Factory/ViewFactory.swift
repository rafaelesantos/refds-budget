import SwiftUI
import RefdsRedux
import RefdsBudgetPresentation

public class ViewFactory: ViewFactoryProtocol {
    public init() {}
    
    public func makeAddBudgetView(
        state: Binding<AddBudgetStateProtocol>,
        action: @escaping (AddBudgetAction) -> Void
    ) -> any View {
        AddBudgetView(
            state: state,
            action: action
        )
    }
    
    public func makeAddCategoryView(
        state: Binding<AddCategoryStateProtocol>,
        action: @escaping (AddCategoryAction) -> Void
    ) -> any View {
        AddCategoryView(
            state: state,
            action: action
        )
    }
    
    public func makeCategoryView(
        state: Binding<CategoryStateProtocol>,
        action: @escaping (CategoryAction) -> Void
    ) -> any View {
        CategoryView(
            state: state,
            action: action
        )
    }
    
    public func makeCegoriesView(
        state: Binding<CategoriesStateProtocol>,
        action: @escaping (CategoriesAction) -> Void
    ) -> any View {
        CategoriesView(
            state: state,
            action: action
        )
    }
    
    public func makeAddTransactionView(
        state: Binding<AddTransactionStateProtocol>,
        action: @escaping (AddTransactionAction) -> Void
    ) -> any View {
        AddTransactionView(
            state: state,
            action: action
        )
    }
    
    public func makeTransactionsView(
        state: Binding<TransactionsStateProtocol>,
        action: @escaping (TransactionsAction) -> Void
    ) -> any View {
        TransactionsView(
            state: state,
            action: action
        )
    }
}