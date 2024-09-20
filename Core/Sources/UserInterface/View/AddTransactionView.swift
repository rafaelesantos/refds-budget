import SwiftUI
import RefdsUI
import RefdsShared
import Domain
import Presentation

public struct AddTransactionView: View {
    @Environment(\.navigate) private var navigate
    
    @Binding private var state: AddTransactionStateProtocol
    private let action: (AddTransactionAction) -> Void
    
    @State private var amount: Double = .zero
    @State private var description: String = ""
    @State private var hasAI: Bool = true
    
    private var bindingCategory: Binding<String?> {
        Binding {
            state.category?.name ?? .localizable(by: .addBudgetEmptyCategories)
        } set: { name in
            if let category = state.categories.first(where: { $0.name.lowercased() == name?.lowercased() ?? "" }) {
                withAnimation {
                    state.category = category
                    hasAI = false
                }
            }
        }
    }
    
    private var bindingDate: Binding<Date> {
        Binding {
            state.date
        } set: {
            let newDate = $0.asString(withDateFormat: .monthYear)
            let currentDate = state.date.asString(withDateFormat: .monthYear)
            if newDate != currentDate || hasAI { action(.fetchCategories($0, amount)) }
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
            sectionStatus
            sectionDescription
            sectionCategory
            sectionSaveButtonView
        }
        .navigationTitle(String.localizable(by: .addTransactionNavigationTitle))
        .refreshable { action(.fetchCategories(state.date, amount)) }
        .toolbar { ToolbarItem { saveButtonToolbar } }
        .onAppear { fetchDataOnAppear() }
        .onChange(of: description) { action(.fetchTags(description)) }
        .refdsDismissesKeyboad()
        .refdsToast(item: $state.error)
    }
    
    private func fetchDataOnAppear() {
        description = description.isEmpty ? state.description : description
        amount = amount == .zero ? state.amount : amount
        hasAI = state.hasAI
        guard state.category == nil else { return }
        action(.fetchCategories(state.date, amount))
    }
    
    private var sectionAmount: some View {
        RefdsSection {} footer: {
            RefdsCurrencyTextField(
                value: $amount,
                style: .largeTitle,
                weight: .bold
            )
            .padding(.top)
        }
    }
    
    private var sectionDescription: some View {
        RefdsSection {
#if os(macOS)
                RefdsTextField(
                    .localizable(by: .addTransactionDescriptionPrompt),
                    text: $description,
                    axis: .vertical,
                    style: .callout
                )
#else
                RefdsTextField(
                    .localizable(by: .addTransactionDescriptionPrompt),
                    text: $description,
                    axis: .vertical,
                    style: .callout,
                    textInputAutocapitalization: .sentences
                )
#endif
        } header: {
            HStack {
                RefdsText(
                    .localizable(by: .addBudgetDescriptionHeader),
                    style: .footnote,
                    color: .secondary
                )
                
                Spacer()
                
                RefdsText(
                    description.count.asString,
                    style: .footnote,
                    color: .secondary
                )
            }
        } footer: {
            ScrollView(.horizontal) {
                HStack(spacing: .extraSmall) {
                    ForEach(state.tags, id: \.id) {
                        tagItemView(for: $0)
                    }
                }
                .padding(.horizontal, 40)
            }
            .scrollIndicators(.never)
            .padding(.horizontal, -40)
            .padding(.top, 5)
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
                HStack(spacing: 15) {
                    if let icon = state.status.icon {
                        RefdsIconRow(icon, color: state.status.color)
                    }
                    RefdsText(.localizable(by: .addTransactionStatusSelect), style: .callout)
                }
            }
            .tint(state.status.color)
            
            rowDate
        } header: {
            RefdsText(
                .localizable(by: .addTransactionStatusHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var sectionCategory: some View {
        RefdsSection {
            loadingView
            if !state.isLoading {
                if !state.isEmptyBudgets, !state.categories.isEmpty {
                    RefdsStories(
                        selection: bindingCategory,
                        stories: state.categories.map {
                            RefdsStoriesViewData(
                                name: $0.name,
                                color: $0.color,
                                icon: RefdsIconSymbol(rawValue: $0.icon) ?? .dollarsign
                            )
                        },
                        size: 45,
                        spacing: .zero
                    )
                }
                
                if state.isEmptyBudgets {
                    EmptyBudgetsView(viewStates: [.date(state.date)])
                }
            }
        } header: {
            HStack {
                RefdsText(
                    .localizable(by: .addBudgetCategoryHeader),
                    style: .footnote,
                    color: .secondary
                )
                
                Spacer(minLength: .zero)
                
                if let category = state.category {
                    let spend = category.spend + state.amount
                    let percentage = spend / (category.budget == .zero ? 1 : category.budget)
                    RefdsScaleProgressView(.circle, riskColor: percentage.riskColor, size: 25)
                }
            }
        } footer: {
            HStack {
                AISuggestionLabel(isEnable: hasAI)
            }
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        if state.isLoading {
            HStack {
                Spacer()
                RefdsLoadingView()
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var rowEmptyCategories: some View {
        if state.categories.isEmpty, !state.isLoading {
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
            HStack(spacing: .medium) {
                if let category = state.category,
                   let icon = RefdsIconSymbol(rawValue: category.icon) {
                    RefdsIcon(
                        icon,
                        color: category.color,
                        size: .medium
                    )
                    .frame(width: .medium, height: .medium)
                    .padding(10)
                    .background(category.color.opacity(0.2))
                    .clipShape(.rect(cornerRadius: .cornerRadius))
                    
                    let spend = category.spend + state.amount
                    let percentage = spend / (category.budget == .zero ? 1 : category.budget)
                    RefdsScaleProgressView(riskColor: percentage.riskColor)
                        .padding(.vertical, 2)
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
                }
            }
        }
    }
    
    private var rowDate: some View {
        DatePicker(
            selection: bindingDate,
            displayedComponents: [.date, .hourAndMinute]
        ) {
            VStack(alignment: .leading) {
                RefdsText(
                    .localizable(by: .addBudgetDateHeader),
                    style: .callout
                )
                RefdsText(
                    state.date.asString(withDateFormat: .custom("EEEE")).capitalized,
                    style: .callout,
                    color: .secondary
                )
            }
        }
        .datePickerStyle(.compact)
        .environment(\.locale, Locale(identifier: "us"))
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
            isDisable: !canSave
        ) {
            action(.save(amount, description))
        }
    }
    
    private var saveButtonToolbar: some View {
        RefdsButton(isDisable: !canSave) {
            action(.save(amount, description))
        } label: {
            RefdsIcon(
                .checkmarkCircleFill,
                color: .accentColor,
                size: 18,
                weight: .bold,
                renderingMode: .hierarchical
            )
        }
    }
    
    private func tagItemView(for tag: TagItemViewDataProtocol) -> some View {
        HStack(spacing: 5) {
            RefdsIcon(
                tag.icon,
                color: tag.color,
                size: .small
            )
            .frame(height: .small)
            
            RefdsText(
                tag.name.uppercased(),
                style: .footnote,
                color: tag.color
            )
        }
        .padding(.vertical, 3)
        .padding(.horizontal, 5)
        .background(tag.color.opacity(0.2))
        .clipShape(.rect(cornerRadius: 4))
    }
    
    private var canSave: Bool {
        amount > 0 &&
        description.isEmpty == false &&
        state.category != nil
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = StoreFactory.development
        
        var body: some View {
            AddTransactionView(state: $store.state.addTransactionState) {
                store.dispatch(action: $0)
            }
        }
    }
    return ContainerView()
}
