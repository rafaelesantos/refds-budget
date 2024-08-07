import SwiftUI
import RefdsUI
import RefdsShared
import RefdsRedux
import RefdsBudgetPresentation

public struct AddBudgetView: View {
    @Binding private var state: AddBudgetStateProtocol
    private let action: (AddBudgetAction) -> Void
    
    private var bindingMonth: Binding<String> {
        Binding {
            state.month.asString(withDateFormat: .month)
        } set: {
            if let year = state.month.asString(withDateFormat: .year).asInt,
               let date = ("\($0)/\(year)").asDate(withFormat: .fullMonthYear) {
                state.month = date
            }
        }
    }
    
    private var bindingYear: Binding<Int> {
        Binding {
            state.month.asString(withDateFormat: .year).asInt ?? .zero
        } set: {
            let month = state.month.asString(withDateFormat: .month)
            if let date = ("\(month)/\($0)").asDate(withFormat: .fullMonthYear) {
                state.month = date
            }
        }
    }
    
    private var bindingCategory: Binding<String> {
        Binding {
            state.category?.name ?? .localizable(by: .addBudgetEmptyCategories)
        } set: { name in
            if let category = state.categories.first(where: { $0.name.lowercased() == name.lowercased() }) {
                state.category = category
                action(.fetchBudget)
            }
        }
    }
    
    public init(
        state: Binding<AddBudgetStateProtocol>,
        action: @escaping (AddBudgetAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    public var body: some View {
        List {
            sectionAmount
            sectionDescription
            sectionDate
            sectionCategory
            sectionSaveButton
        }
        .refreshable { action(.fetchBudget) }
        .onChange(of: state.month) { action(.fetchBudget) }
        .onChange(of: state.category?.name ?? "") { action(.fetchBudget) }
        .onAppear { fetchDataOnAppear() }
        .refdsDismissesKeyboad()
        .refdsToast(item: $state.error)
    }
    
    private func fetchDataOnAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
           action(.fetchCategories)
        }
    }
    
    private var sectionAmount: some View {
        RefdsSection {} footer: {
            VStack {
                RefdsCurrencyTextField(
                    value: $state.amount,
                    style: .largeTitle,
                    weight: .bold
                )
                
                AISuggestionLabel(isEnable: state.isAI)
            }
        }
    }
    
    private var sectionDescription: some View {
        RefdsSection {
            #if os(macOS)
            RefdsTextField(
                .localizable(by: .addBudgetDescriptionBudget),
                text: $state.description,
                axis: .vertical,
                style: .callout
            )
            #else
            RefdsTextField(
                .localizable(by: .addBudgetDescriptionBudget),
                text: $state.description,
                axis: .vertical,
                style: .callout,
                textInputAutocapitalization: .sentences
            )
            #endif
        } header: {
            RefdsText(
                .localizable(by: .addBudgetDescriptionHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var sectionDate: some View {
        RefdsSection {
            rowMonth
            rowYear
        } header: {
            RefdsText(
                .localizable(by: .addBudgetDateHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var rowMonth: some View {
        Picker(selection: bindingMonth) {
            let months = Calendar.current.monthSymbols
            ForEach(months, id: \.self) {
                RefdsText($0.capitalized)
                    .tag($0)
            }
        } label: {
            RefdsText(
                .localizable(by: .addBudgetSelectedMonth),
                style: .callout
            )
        }
        .tint(.secondary)
    }
    
    private var rowYear: some View {
        Picker(selection: bindingYear) {
            let currentYear = Date().asString(withDateFormat: .year).asInt ?? .zero
            let padding = Int(CGFloat.padding(.extraSmall))
            let years = ((currentYear - padding) ... (currentYear + padding)).map { $0 }
            ForEach(years, id: \.self) {
                RefdsText($0.asString)
                    .tag($0)
            }
        } label: {
            RefdsText(
                .localizable(by: .addBudgetSelectedYear),
                style: .callout
            )
        }
        .tint(.secondary)
    }
    
    private var sectionCategory: some View {
        RefdsSection {
            LoadingRowView(isLoading: state.isLoading)
            if !state.isLoading {
                rowEmptyCategories
                rowCategories
            }
        } header: {
            RefdsText(
                .localizable(by: .addBudgetCategoryHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    @ViewBuilder
    private var rowEmptyCategories: some View {
        if state.categories.isEmpty {
            RefdsText(
                .localizable(by: .categoriesEmptyCategoriesDescription),
                style: .callout,
                color: .secondary
            )
            RefdsButton { action(.addCategory) } label: {
                RefdsText(.localizable(by: .categoriesEmptyCategoriesButton), style: .callout, color: .accentColor)
            }
        }
    }
    
    @ViewBuilder
    private var rowCategories: some View {
        if !state.categories.isEmpty {
            Picker(selection: bindingCategory) {
                let categories: [String] = state.categories.map { $0.name }
                ForEach(categories, id: \.self) {
                    RefdsText($0.capitalized)
                        .tag($0)
                }
            } label: {
                HStack(spacing: .padding(.medium)) {
                    if let category = state.category {
                        RefdsIcon(
                            category.icon,
                            color: category.color,
                            size: .padding(.medium)
                        )
                        .frame(width: .padding(.medium), height: .padding(.medium))
                        .padding(10)
                        .background(category.color.opacity(0.2))
                        .clipShape(.rect(cornerRadius: .cornerRadius))
                    }
                    RefdsText(.localizable(by: .addBudgetSelectedCategory), style: .callout)
                }
            }
            .tint(.secondary)
        }
    }
    
    private var sectionSaveButton: some View {
        RefdsSection {} footer: {
            saveButton
                .padding(.horizontal, -20)
                .padding(.bottom, 20)
        }
    }
    
    private var saveButton: some View {
        RefdsButton(
            .localizable(by: .addBudgetAdd),
            isDisable: !state.canSave
        ) {
            action(.save(state))
        }
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = StoreFactory.development
        
        var body: some View {
            AddBudgetView(state: $store.state.addBudgetState) {
                store.dispatch(action: $0)
            }
        }
    }
    return ContainerView()
}
