import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsBudgetResource
import RefdsBudgetPresentation

public struct CategoriesView: View {
    @Binding private var state: CategoriesStateProtocol
    private let action: (CategoriesAction) -> Void
    
    public init(
        state: Binding<CategoriesStateProtocol>,
        action: @escaping (CategoriesAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    public var body: some View {
        List {
            sectionAmount
            sectionsCategory
        }
        .navigationTitle(String.localizable(by: .categoriesNavigationTitle))
        .refreshable { reloadData() }
        .onAppear { reloadData() }
    }
    
    private func reloadData() {
        action(.fetchCurrentValues(state.isFilterEnable ? state.date : nil))
        action(.fetchCategories(state.isFilterEnable ? state.date : nil))
    }
    
    private var sectionsCategory: some View {
        ForEach(state.categories.indices, id: \.self) { index in
            let category = state.categories[index]
            CategoryRowView(viewData: category)
        }
    }
    
    @ViewBuilder
    private var sectionAmount: some View {
        if let currentValues = state.currentValues {
            Section {
                CurrentValueView(viewData: currentValues)
                HStack {
                    RefdsText(
                        .localizable(by: .categoriesPeriod),
                        style: .callout
                    )
                    Spacer()
                    RefdsText(
                        state.date.asString(withDateFormat: .month).uppercased(),
                        style: .footnote,
                        color: .accentColor,
                        weight: .bold
                    )
                    RefdsText(
                        state.date.asString(withDateFormat: .year),
                        style: .footnote,
                        weight: .bold
                    )
                }
            } header: {
                RefdsText(
                    .localizable(
                        by: .categoriesStatus
                    ),
                    style: .footnote,
                    color: .secondary
                )
            }
        }
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = RefdsReduxStore.mock(
            reducer: CategoriesReducer().reduce,
            state: CategoriesStateMock()
        )
        
        var body: some View {
            NavigationStack {
                CategoriesView(state: $store.state) {
                    store.dispatch(action: $0)
                }
            }
        }
    }
    return ContainerView()
}
