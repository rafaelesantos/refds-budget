import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsShared
import RefdsBudgetPresentation

public struct TagsView: View {
    @Binding private var state: TagsStateProtocol
    private let action: (TagAction) -> Void
    
    @State private var isEditingMode = false
    
    public init(
        state: Binding<TagsStateProtocol>,
        action: @escaping (TagAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    public var body: some View {
        List {
            if isEditingMode || (state.tags.isEmpty && !state.isLoading) {
                sectionsInput
            }
            
            LoadingRowView(isLoading: state.isLoading)
            sectionTags
        }
        .refreshable { action(.fetchData) }
        .onAppear { fetchDataOnAppear() }
        .toolbar { ToolbarItem { addButtonToolbar } }
        .refdsDismissesKeyboad()
        .refdsToast(item: $state.error)
        .navigationTitle(String.localizable(by: .tagsNavigationTitle))
    }
    
    @ViewBuilder
    private var sectionsInput: some View {
        sectionName
        ColorFormView(color: $state.selectedTag.color)
        IconsFormView(icon: $state.selectedTag.icon, color: state.selectedTag.color)
        sectionSaveButton
        LoadingRowView(isLoading: state.isLoading)
        rowHideInput
        
    }
    
    private func fetchDataOnAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            action(.fetchData)
        }
    }
    
    private var rowHideInput: some View {
        RefdsButton {
            state.selectedTag = TagRowViewData()
            withAnimation { isEditingMode.toggle() }
        } label: {
            HStack {
                RefdsText(
                    .localizable(by: .tagsCleanSelected),
                    style: .callout,
                    weight: .bold
                )
                
                Spacer()
                
                RefdsIcon(.chevronUp, color: .placeholder)
            }
        }
    }
    
    private var sectionName: some View {
        RefdsSection {} footer: {
            #if os(macOS)
            RefdsTextField(
                .localizable(by: .tagsInputNamePlaceholder),
                text: $state.selectedTag.name,
                axis: .vertical,
                style: .largeTitle,
                color: .primary,
                weight: .bold,
                alignment: .center
            )
            #else
            RefdsTextField(
                .localizable(by: .tagsInputNamePlaceholder),
                text: $state.selectedTag.name,
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
    
    private var sectionTags: some View {
        RefdsSection {
            ForEach(state.tags.indices, id: \.self) { index in
                let tag = state.tags[index]
                RefdsButton {
                    withAnimation { 
                        isEditingMode = true
                        state.selectedTag = tag
                    }
                } label: {
                    TagRowView(
                        viewData: tag,
                        isSelected: state.selectedTag.id == tag.id
                    )
                }
                .contextMenu {
                    contextRemoveButton(at: index)
                    contextEditButton(at: index)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    swipeRemoveButton(at: index)
                    swipeEditButton(at: index)
                }
            }
        }
    }
    
    private var sectionSaveButton: some View {
        RefdsSection {} footer: {
            saveButton
                .padding(.horizontal, -20)
        }
    }
    
    private var saveButton: some View {
        RefdsButton(
            .localizable(by: .tagsSaveButton),
            isDisable: !state.canSave
        ) {
            withAnimation { isEditingMode = false }
            action(.save)
        }
    }
    
    @ViewBuilder
    private var addButtonToolbar: some View {
        if !state.tags.isEmpty, !isEditingMode {
            RefdsButton {
                state.selectedTag = TagRowViewData()
                withAnimation { isEditingMode.toggle() }
            } label: {
                RefdsIcon(
                    isEditingMode ? .xmarkCircleFill : .plusCircleFill,
                    color: .accentColor,
                    size: 18,
                    weight: .bold,
                    renderingMode: .hierarchical
                )
            }
        }
    }
    
    private func swipeRemoveButton(at index: Int) -> some View {
        RefdsButton {
            action(.removeTag(state.tags[index].id))
        } label: {
            RefdsIcon(.trashFill)
        }
        .tint(.red)
    }
    
    private func contextRemoveButton(at index: Int) -> some View {
        RefdsButton {
            action(.removeTag(state.tags[index].id))
        } label: {
            Label(
                String.localizable(by: .tagsRemoveTag),
                systemImage: RefdsIconSymbol.trashFill.rawValue
            )
        }
    }
    
    private func swipeEditButton(at index: Int) -> some View {
        RefdsButton {
            withAnimation {
                isEditingMode = true
                state.selectedTag = state.tags[index]
            }
        } label: {
            RefdsIcon(.squareAndPencil)
        }
        .tint(.orange)
    }
    
    private func contextEditButton(at index: Int) -> some View {
        RefdsButton {
            withAnimation {
                isEditingMode = true
                state.selectedTag = state.tags[index]
            }
        } label: {
            Label(
                String.localizable(by: .tagsEditTag),
                systemImage: RefdsIconSymbol.squareAndPencil.rawValue
            )
        }
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = StoreFactory.development
        
        var body: some View {
            NavigationStack {
                TagsView(state: $store.state.tagsState) {
                    store.dispatch(action: $0)
                }
            }
        }
    }
    return ContainerView()
}
