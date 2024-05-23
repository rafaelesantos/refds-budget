import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetDomain
import RefdsBudgetPresentation

public struct AddTransactionView: View {
    @Binding private var state: AddTransactionStateProtocol
    private let action: (AddTransactionAction) -> Void
    
    private var bindingCategory: Binding<String> {
        Binding {
            state.category?.name ?? .localizable(by: .addBudgetEmptyCategories)
        } set: { name in
            if let category = state.categories.first(where: { $0.name.lowercased() == name.lowercased() }) {
                state.category = category
            }
        }
    }
    
    private var bindingDate: Binding<Date> {
        Binding {
            state.date
        } set: {
            let newDate = $0.asString(withDateFormat: .monthYear)
            let currentDate = state.date.asString(withDateFormat: .monthYear)
            if newDate != currentDate { action(.fetchCategories($0)) }
            state.date = $0
        }
    }
    
    public init(
        state: Binding<AddTransactionStateProtocol>,
        action: @escaping (AddTransactionAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    public var body: some View {
        List {
            sectionAmount
            sectionDescription
            sectionStatus
            sectionEmptyCategories
            sectionEmptyBudgets
            sectionCategory
            sectionDate
            sectionSaveButtonView
        }
        #if os(macOS)
        .listStyle(.plain)
        #elseif os(iOS)
        .listStyle(.insetGrouped)
        #endif
        .refreshable { action(.fetchCategories(state.date)) }
        .onAppear { fetchDataOnAppear() }
        .refdsDismissesKeyboad()
        .refdsToast(item: $state.error)
        .navigationTitle(String.localizable(by: .addTransactionNavigationTitle))
        .refdsToast(item: $state.error)
    }
    
    private func fetchDataOnAppear() {
        guard state.category == nil else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            action(.fetchCategories(state.date))
        }
    }
    
    private var sectionAmount: some View {
        RefdsSection {} footer: {
            RefdsCurrencyTextField(
                value: $state.amount,
                style: .largeTitle,
                weight: .bold
            )
        }
    }
    
    private var sectionDescription: some View {
        RefdsSection {
            #if os(macOS)
            RefdsTextField(
                .localizable(by: .addTransactionDescriptionPrompt),
                text: $state.description,
                axis: .vertical,
                style: .callout
            )
            #else
            RefdsTextField(
                .localizable(by: .addTransactionDescriptionPrompt),
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
    
    private var sectionStatus: some View {
        RefdsSection {
            Picker(selection: $state.status) {
                ForEach(TransactionStatus.allCases.indices, id: \.self) {
                    let status = TransactionStatus.allCases[$0]
                    RefdsText(status.description)
                        .tag(status)
                }
            } label: {
                RefdsText(.localizable(by: .addTransactionStatusSelect), style: .callout)
            }
            .tint(.secondary)
        } header: {
            RefdsText(
                .localizable(by: .addTransactionStatusHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    @ViewBuilder
    private var sectionCategory: some View {
        if !state.isEmptyCategories, !state.isEmptyBudgets {
            RefdsSection {
                rowCategories
            } header: {
                RefdsText(
                    .localizable(by: .addBudgetCategoryHeader),
                    style: .footnote,
                    color: .secondary
                )
            }
        }
    }
    
    @ViewBuilder
    private var rowEmptyCategories: some View {
        if state.categories.isEmpty {
            RefdsText(
                .localizable(by: .addBudgetEmptyCategories),
                style: .callout,
                color: .secondary
            )
        }
    }
    
    @ViewBuilder
    private var rowCategories: some View {
        if !state.categories.isEmpty {
            HStack(spacing: .padding(.medium)) {
                if let category = state.category,
                   let icon = RefdsIconSymbol(rawValue: category.icon) {
                    RefdsIcon(
                        icon,
                        color: category.color,
                        size: .padding(.medium)
                    )
                    .frame(width: .padding(.medium), height: .padding(.medium))
                    .padding(10)
                    .background(category.color.opacity(0.2))
                    .clipShape(.rect(cornerRadius: .cornerRadius))
                }
                
                VStack(spacing: .zero) {
                    Picker(selection: bindingCategory) {
                        ForEach(state.categories.map { $0.name }, id: \.self) {
                            RefdsText($0.capitalized)
                                .tag($0)
                        }
                    } label: {
                        RefdsText(.localizable(by: .addBudgetSelectedCategory), style: .callout)
                    }
                    .tint(.secondary)
                    rowPercentage
                }
            }
        }
    }
    
    @ViewBuilder
    private var rowPercentage: some View {
        if let category = state.category {
            HStack(spacing: .padding(.medium)) {
                let spend = category.spend + state.amount
                let percentage = spend / (category.budget == .zero ? 1 : category.budget)
                ProgressView(value: percentage > 1 ? 1 : percentage, total: 1)
                    .tint(percentage.riskColor)
                #if os(iOS)
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
                #endif
                    .animation(.default, value: percentage)
                RefdsText(percentage.percent(), style: .callout, color: .secondary)
            }
        }
    }
    
    private var sectionDate: some View {
        RefdsSection {
            RefdsText(
                state.date.asString(withDateFormat: .custom("EEEE dd,  MMMM yyyy - HH:mm")),
                style: .callout,
                color: .secondary
            )
            
            #if os(macOS)
            DatePicker(selection: bindingDate) { EmptyView() }
            #else
            DatePicker(selection: bindingDate) { EmptyView() }
                .datePickerStyle(.graphical)
            #endif
        } header: {
            RefdsText(
                .localizable(by: .addBudgetDateHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    @ViewBuilder
    private var sectionEmptyBudgets: some View {
        if !state.isEmptyCategories, state.isEmptyBudgets {
            RefdsSection {
                RefdsText(.localizable(by: .categoriesEmptyBudgetsDescription), style: .callout)
                RefdsButton { action(.addBudget(state.date)) } label: {
                    RefdsText(.localizable(by: .categoriesEmptyBudgetsButton), style: .callout, color: .accentColor)
                }
            } header: {
                RefdsText(.localizable(by: .categoriesEmptyBudgetsTitle), style: .footnote, color: .secondary)
            }
        }
    }
    
    @ViewBuilder
    private var sectionEmptyCategories: some View {
        if state.isEmptyCategories {
            RefdsSection {
                RefdsText(.localizable(by: .categoriesEmptyCategoriesDescription), style: .callout)
                RefdsButton { action(.addCategory) } label: {
                    RefdsText(.localizable(by: .categoriesEmptyCategoriesButton), style: .callout, color: .accentColor)
                }
            } header: {
                RefdsText(.localizable(by: .categoriesEmptyCategoriesTitle), style: .footnote, color: .secondary)
            }
        }
    }
    
    private var sectionSaveButtonView: some View {
        RefdsSection {} footer: {
            saveButton
                .padding(.horizontal, -20)
                .padding(.bottom, 20)
        }
    }
    
    private var saveButton: some View {
        RefdsButton(
            .localizable(by: .addTransactionSaveButton),
            isDisable: !state.canSave
        ) {
            action(.save(state))
        }
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = RefdsReduxStoreFactory.development
        
        var body: some View {
            AddTransactionView(state: $store.state.addTransactionState) {
                store.dispatch(action: $0)
            }
        }
    }
    return ContainerView()
}
