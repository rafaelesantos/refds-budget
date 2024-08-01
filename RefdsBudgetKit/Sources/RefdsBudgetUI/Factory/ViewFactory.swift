import SwiftUI
import RefdsRedux
import RefdsBudgetDomain
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
    
    public func makeTagView(
        state: Binding<TagsStateProtocol>,
        action: @escaping (TagAction) -> Void
    ) -> any View {
        TagsView(
            state: state,
            action: action
        )
    }
    
    public func makeHomeView(
        state: Binding<HomeStateProtocol>,
        action: @escaping (HomeAction) -> Void
    ) -> any View {
        HomeView(
            state: state,
            action: action
        )
    }
    
    public func makeSettingsView(
        state: Binding<SettingsStateProtocol>,
        action: @escaping (SettingsAction) -> Void
    ) -> any View {
        SettingsView(
            state: state,
            action: action
        )
    }
    
    public func makeSubscriptionView(
        state: Binding<SettingsStateProtocol>,
        action: @escaping (SettingsAction) -> Void
    ) -> any View {
        SubscriptionView(
            state: state,
            action: action
        )
    }
    
    public func makeImportView(
        state: Binding<ImportStateProtocol?>,
        action: @escaping (ImportAction) -> Void
    ) -> any View {
        ImportView(
            state: state,
            action: action
        )
    }
    
    public func makeBudgetSelectionView(
        state: Binding<BudgetSelectionStateProtocol>,
        action: @escaping (BudgetSelectionAction) -> Void
    ) -> any View {
        BudgetSelectionView(
            state: state,
            action: action
        )
    }
    
    public func makeBudgetComparisonView(
        state: Binding<BudgetComparisonStateProtocol>,
        action: @escaping (BudgetComparisonAction) -> Void
    ) -> any View {
        BudgetComparisonView(
            state: state,
            action: action
        )
    }
}
