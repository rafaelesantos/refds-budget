import SwiftUI
import RefdsRedux
import RefdsBudgetPresentation

public class ViewFactory: ViewFactoryProtocol {
    public init() {}
    
    public func makeAddBudgetView(
        state: Binding<BudgetStateProtocol>,
        action: @escaping (AddBudgetAction) -> Void
    ) -> any View {
        AddBudgetView(
            state: state,
            action: action
        )
    }
    
    public func makeAddCategoryView(
        state: Binding<CategoryStateProtocol>,
        action: @escaping (AddCategoryAction) -> Void
    ) -> any View {
        AddCategoryView(
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
}
