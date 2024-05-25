import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsShared
import RefdsBudgetPresentation

public struct TagsView: View {
    @Binding private var state: TagsStateProtocol
    private let action: (TagAction) -> Void
    
    public init(
        state: Binding<TagsStateProtocol>,
        action: @escaping (TagAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    public var body: some View {
        List {
            sectionInput
            sectionSaveButton
            sectionTags
        }
        .refreshable { action(.fetchData) }
        .onAppear { fetchDataOnAppear() }
        .refdsDismissesKeyboad()
        .refdsToast(item: $state.error)
        .navigationTitle(String.localizable(by: .tagsNavigationTitle))
    }
    
    private func fetchDataOnAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            action(.fetchData)
        }
    }
    
    private var sectionInput: some View {
        RefdsSection {
            rowName
            rowColors
            rowHexColor
            cleanButton
        } header: {
            RefdsText(
                .localizable(by: .tagsInputHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var rowName: some View {
        #if os(macOS)
        RefdsTextField(
            .localizable(by: .tagsInputNamePlaceholder),
            text: $state.selectedTag.name,
            axis: .vertical,
            style: .callout
        )
        #else
        RefdsTextField(
            .localizable(by: .tagsInputNamePlaceholder),
            text: $state.selectedTag.name,
            axis: .vertical,
            style: .callout,
            textInputAutocapitalization: .sentences
        )
        #endif
    }
    
    private var rowColors: some View {
        HStack(spacing: .padding(.medium)) {
            BubbleColorView(color: state.selectedTag.color, isSelected: true)
            Divider().frame(height: 30)
            ScrollView(.horizontal) {
                HStack {
                    let colors = Color.Default.allCases.sorted(by: { $0.id < $1.id })
                    ForEach(colors, id: \.self) { color in
                        RefdsButton {
                            state.selectedTag.color = color.rawValue
                        } label: {
                            BubbleColorView(color: color.rawValue)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.never)
            .padding(.horizontal, -20)
        }
    }
    
    private var rowHexColor: some View {
        ColorPicker(selection: $state.selectedTag.color) {
            RefdsText(
                .localizable(by: .addCategoryInputHex),
                style: .callout
            )
        }
    }
    
    private var sectionTags: some View {
        RefdsSection {
            ForEach(state.tags.indices, id: \.self) { index in
                let tag = state.tags[index]
                RefdsButton {
                    withAnimation { state.selectedTag = tag }
                } label: {
                    TagRowView(viewData: tag)
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
        } header: {
            RefdsText(
                .localizable(by: .tagsNavigationTitle),
                style: .footnote,
                color: .secondary
            )
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
            action(.save)
        }
    }
    
    @ViewBuilder
    private var cleanButton: some View {
        if state.tags.contains(where: { $0.id == state.selectedTag.id }) {
            RefdsButton {
                withAnimation {
                    state.selectedTag = TagRowViewData()
                }
            } label: {
                RefdsText(
                    .localizable(by: .tagsCleanSelected),
                    style: .callout,
                    color: .red
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
            state.selectedTag = state.tags[index]
        } label: {
            RefdsIcon(.squareAndPencil)
        }
        .tint(.orange)
    }
    
    private func contextEditButton(at index: Int) -> some View {
        RefdsButton {
            state.selectedTag = state.tags[index]
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
