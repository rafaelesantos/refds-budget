import SwiftUI
import RefdsUI
import RefdsShared
import Mock
import Domain
import Presentation

public struct AddBudgetView: View {
    @Environment(\.navigate) private var navigate
    
    @Binding private var state: AddBudgetStateProtocol
    private let action: (AddBudgetAction) -> Void
    
    private var bindingCategory: Binding<String?> {
        Binding {
            state.category?.name
        } set: { name in
            if let category = state.categories.first(where: { $0.name == name }) {
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
            sectionAISuggestion
            sectionDescription
            sectionDate
            sectionCategory
            sectionSaveButton
        }
        .onAppear { reloadData() }
        .onChange(of: state.date) { action(.fetchBudget) }
        .onChange(of: state.amount) { state.hasAISuggestion = false }
        .toolbar { ToolbarItem { saveButtonToolbar } }
        .refdsDismissesKeyboad()
        .refdsToast(item: $state.error)
        .refdsLoading(state.isLoading)
    }
    
    private func reloadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            action(.fetchData)
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
    
    private var sectionAISuggestion: some View {
        RefdsSection {
            RefdsButton {
                state.hasAISuggestion = true
                action(.fetchBudget)
            } label: {
                HStack(spacing: .medium) {
                    RefdsIconRow(
                        .cpuFill,
                        color: .accentColor
                    )
                    RefdsText(.localizable(by: .aiTitle))
                    Spacer()
                    RefdsIcon(
                        .chevronRight,
                        color: .secondary.opacity(0.5),
                        style: .callout
                    )
                }
            }
        } header: {
            RefdsText(
                .localizable(by: .addBudgetAISuggestion),
                style: .footnote,
                color: .secondary
            )
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
            .frame(minHeight: 38)
            #else
            RefdsTextField(
                .localizable(by: .addBudgetDescriptionBudget),
                text: $state.description,
                axis: .vertical,
                style: .callout,
                textInputAutocapitalization: .sentences
            )
            .frame(minHeight: 38)
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
            HStack(spacing: .medium) {
                RefdsIconRow(.calendar)
                DateView(date: $state.date)
            }
        } header: {
            RefdsText(
                .localizable(by: .addBudgetDateHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var sectionCategory: some View {
        RefdsSection {
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
        if state.categories.isEmpty, !state.isLoading {
            EmptyCategoriesView()
        }
    }
    
    @ViewBuilder
    private var rowCategories: some View {
        if !state.categories.isEmpty {
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
    }
    
    private var sectionSaveButton: some View {
        RefdsSection {} footer: {
            saveButton
                .padding(.horizontal, -20)
                .padding(.bottom, 20)
        }
    }
    
    private var saveButtonToolbar: some View {
        RefdsButton(isDisable: !state.canSave) { 
            action(.save)
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
    
    private var saveButton: some View {
        RefdsButton(
            .localizable(by: .addBudgetAdd),
            isDisable: !state.canSave
        ) {
            action(.save)
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
