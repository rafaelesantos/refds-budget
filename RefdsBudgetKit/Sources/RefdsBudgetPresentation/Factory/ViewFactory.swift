import SwiftUI

public protocol ViewFactoryProtocol {
    func makeAddBudgetView(
        state: Binding<BudgetStateProtocol>,
        action: @escaping (AddBudgetAction) -> Void
    ) -> any View
    
    func makeAddCategoryView(
        state: Binding<CategoryStateProtocol>,
        action: @escaping (AddCategoryAction) -> Void
    ) -> any View
    
    func makeCegoriesView(
        state: Binding<CategoriesStateProtocol>,
        action: @escaping (CategoriesAction) -> Void
    ) -> any View
}
