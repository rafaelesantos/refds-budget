import SwiftUI
import RefdsRedux
import RefdsRouter
import RefdsInjection

public enum ApplicationRoute: RefdsRoutableRedux {
    case addBudget
    case addCategory
    case category
    case addTransaction
    case manageTags
    case settings
    case `import`
    
    public var navigationType: RefdsNavigationType {
        switch self {
        default: return .push
        }
    }
    
    private var viewFactory: ViewFactoryProtocol {
        RefdsContainer.resolve(type: ViewFactoryProtocol.self)
    }
    
    private func bindingState(_ state: Binding<RefdsReduxState>) -> Binding<ApplicationStateProtocol>? {
        guard let wrappedValue = state.wrappedValue as? ApplicationStateProtocol else { return nil }
        return Binding { wrappedValue } set: {
            state.wrappedValue = $0
        }
    }
    
    @ViewBuilder
    public func view(
        router: RefdsRouterRedux<ApplicationRoute>,
        state: Binding<RefdsReduxState>,
        action: @escaping (RefdsReduxAction) -> Void
    ) -> some View {
        if let state = bindingState(state) {
            switch self {
            case .addBudget: AnyView(viewFactory.makeAddBudgetView(state: state.addBudgetState, action: action))
            case .addCategory: AnyView(viewFactory.makeAddCategoryView(state: state.addCategoryState, action: action))
            case .category: AnyView(viewFactory.makeCategoryView(state: state.categoryState, action: action))
            case .addTransaction: AnyView(viewFactory.makeAddTransactionView(state: state.addTransactionState, action: action))
            case .manageTags: AnyView(viewFactory.makeTagView(state: state.tagsState, action: action))
            case .settings: AnyView(viewFactory.makeSettingsView(state: state.settingsState, action: action))
            case .import: AnyView(viewFactory.makeImportView(state: state.importState, action: action))
            }
        }
    }
}
