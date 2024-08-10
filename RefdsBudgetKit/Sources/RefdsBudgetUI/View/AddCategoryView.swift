import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsShared
import RefdsBudgetPresentation

public struct AddCategoryView: View {
    @Binding private var state: AddCategoryStateProtocol
    private let action: (AddCategoryAction) -> Void
    
    public init(
        state: Binding<AddCategoryStateProtocol>,
        action: @escaping (AddCategoryAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    public var body: some View {
        List {
            sectionNameView
            ColorFormView(color: $state.color)
            IconsFormView(icon: $state.icon, color: state.color)
            sectionSaveButtonView
        }
        .refdsDismissesKeyboad()
        .toolbar { ToolbarItem { saveButtonToolbar } }
        .refdsToast(item: $state.error)
    }
    
    private var sectionNameView: some View {
        RefdsSection {} footer: {
            #if os(macOS)
            RefdsTextField(
                .localizable(by: .addCategoryInputName),
                text: $state.name,
                axis: .vertical,
                style: .largeTitle,
                color: .primary,
                weight: .bold,
                alignment: .center
            )
            #else
            RefdsTextField(
                .localizable(by: .addCategoryInputName),
                text: $state.name,
                axis: .vertical,
                style: .largeTitle,
                color: .primary,
                weight: .bold,
                alignment: .center,
                textInputAutocapitalization: .words
            )
            #endif
        }
    }
    
    
    
    private var sectionSaveButtonView: some View {
        RefdsSection {} footer: {
            RefdsButton(
                .localizable(by: .addCategorySaveCategoryButton),
                isDisable: !state.canSave
            ) {
                action(.save(state))
            }
            .padding(.horizontal, -20)
            .padding(.bottom, 20)
        }
    }
    
    private var saveButtonToolbar: some View {
        RefdsButton(isDisable: !state.canSave) { action(.save(state)) } label: {
            RefdsIcon(
                .checkmarkCircleFill,
                color: .accentColor,
                size: 18,
                weight: .bold,
                renderingMode: .hierarchical
            )
        }
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = StoreFactory.development
        
        var body: some View {
            AddCategoryView(state: $store.state.addCategoryState) {
                store.dispatch(action: $0)
            }
        }
    }
    return ContainerView()
}

