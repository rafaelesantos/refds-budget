import SwiftUI

import RefdsUI
import RefdsRedux
import RefdsShared
import RefdsInjection

import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetPresentation

public struct AddBudgetView: View {
    @Binding private var state: BudgetStateProtocol
    private let action: (AddBudgetAction) -> Void
    
    private var bindingMonth: Binding<String> {
        Binding {
            state.month.asString(withDateFormat: .month)
        } set: {
            let year = state.month.asString(withDateFormat: .year).asInt ?? .zero
            state.month = ("\($0)/\(year)").asDate(withFormat: .fullMonthYear) ?? .current
            action(.fetchBudget(state.month, state.category?.id ?? .init()))
        }
    }
    
    private var bindingYear: Binding<Int> {
        Binding {
            state.month.asString(withDateFormat: .year).asInt ?? .zero
        } set: {
            let month = state.month.asString(withDateFormat: .month)
            state.month = ("\(month)/\($0)").asDate(withFormat: .fullMonthYear) ?? .current
            action(.fetchBudget(state.month, state.category?.id ?? .init()))
        }
    }
    
    private var bindingCategory: Binding<String> {
        Binding {
            state.category?.name ?? .localizable(by: .addBudgetEmptyCategories)
        } set: { name in
            let category = state.categories.first(where: { $0.name == name })
            state.category = category
            action(.fetchBudget(state.month, state.category?.id ?? .init()))
        }
    }
    
    public init(
        state: Binding<BudgetStateProtocol>,
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
        }
        .refdsDismissesKeyboad()
        .overlay(alignment: .bottom) { saveButton }
        .onAppear { action(.fetchCategories) }
        .refdsToast(item: $state.error)
    }
    
    private var sectionAmount: some View {
        Section {} footer: {
            VStack(spacing: .zero) {
                RefdsText(
                    state.month.asString(withDateFormat: .custom("MMMM, yyyy")).uppercased(),
                    style: .caption,
                    color: .accentColor,
                    weight: .bold
                )
                RefdsCurrencyTextField(
                    value: $state.amount,
                    style: .largeTitle,
                    weight: .bold
                )
            }
        }
    }
    
    private var sectionDescription: some View {
        Section {
            RefdsTextField(
                .localizable(by: .addBudgetDescriptionBudget),
                text: $state.description,
                axis: .vertical,
                style: .callout
            )
        } header: {
            RefdsText(
                .localizable(by: .addBudgetDescriptionHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var sectionDate: some View {
        Section {
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
                RefdsText($0)
                    .tag($0)
            }
        } label: {
            RefdsText(
                .localizable(by: .addBudgetSelectedMonth),
                style: .callout
            )
        }
    }
    
    private var rowYear: some View {
        Picker(selection: bindingYear) {
            let currentYear = Date().asString(withDateFormat: .year).asInt ?? .zero
            let years = ((currentYear - 5) ... (currentYear + 5)).map { $0 }
            ForEach(years, id: \.self) {
                RefdsText("\($0)")
                    .tag($0)
            }
        } label: {
            RefdsText(
                .localizable(by: .addBudgetSelectedYear),
                style: .callout
            )
        }
    }
    
    private var sectionCategory: some View {
        Section {
            rowEmptyCategories
            rowCategories
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
                .localizable(by: .addBudgetEmptyCategories),
                style: .callout,
                color: .secondary
            )
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
                RefdsText(.localizable(by: .addBudgetSelectedCategory), style: .callout)
            }
            .onAppear { action(.fetchBudget(state.month, state.category?.id ?? .init())) }
        }
    }
    
    private var saveButton: some View {
        RefdsButton(
            .localizable(by: .addBudgetAdd),
            isDisable: !state.canSave
        ) {
            action(.save(state))
        }
        .padding(.padding(.large))
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = RefdsReduxStore.mock(
            reducer: AddBudgetReducer().reduce,
            state: AddBudgetStateMock()
        )
        
        var body: some View {
            AddBudgetView(state: $store.state) {
                store.dispatch(action: $0)
            }
        }
    }
    return ContainerView()
}
