import SwiftUI
import RefdsUI
import Charts
import RefdsRedux
import RefdsBudgetPresentation

public struct TagsView: View {
    @Binding private var state: TagsStateProtocol
    private let action: (TagAction) -> Void
    
    private var bindingHexColor: Binding<String> {
        Binding {
            state.selectedTag.color.asHex()
        } set: {
            state.selectedTag.color = Color(hex: $0)
        }
    }
    
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
            sectionFilters
            TagsSectionView(
                tags: state.tags,
                selectedTag: $state.selectedTag,
                action: action
            )
        }
        #if os(macOS)
        .listStyle(.plain)
        #elseif os(iOS)
        .listStyle(.insetGrouped)
        #endif
        .refreshable { action(.fetchData(state.isFilterEnable ? state.date : nil)) }
        .onAppear { fetchDataOnAppear() }
        .onChange(of: state.date) { action(.fetchData(state.isFilterEnable ? state.date : nil)) }
        .onChange(of: state.isFilterEnable) { action(.fetchData(state.isFilterEnable ? state.date : nil)) }
        .refdsDismissesKeyboad()
        .refdsToast(item: $state.error)
        .navigationTitle(String.localizable(by: .tagsNavigationTitle))
    }
    
    private func fetchDataOnAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            action(.fetchData(state.isFilterEnable ? state.date : nil))
        }
    }
    
    private var sectionFilters: some View {
        RefdsSection {
            rowApplyDateFilter
            if state.isFilterEnable {
                DateRowView(date: $state.date) {
                    HStack(spacing: .padding(.medium)) {
                        RefdsIconRow(.calendar)
                        RefdsText(.localizable(by: .categoriesDate), style: .callout)
                    }
                }
            }
        } header: {
            RefdsText(
                .localizable(by: .categoriesFilter),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var bindingFilterEnable: Binding<Bool> {
        Binding {
            state.isFilterEnable
        } set: { isEnable in
            withAnimation {
                state.isFilterEnable = isEnable
            }
        }
    }
    
    private var rowApplyDateFilter: some View {
        RefdsToggle(isOn: bindingFilterEnable) {
            RefdsText(.localizable(by: .transactionsFilterByDate), style: .callout)
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
            text: $state.newTagName,
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
        HStack {
            RefdsText(
                .localizable(by: .addCategoryInputHex),
                style: .callout
            )
            Spacer()
            RefdsTextField(
                Color.green.asHex(),
                text: bindingHexColor,
                style: .callout,
                alignment: .trailing
            )
        }
    }
    
    private var sectionSaveButton: some View {
        RefdsSection {} footer: {
            saveButton
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
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = RefdsReduxStoreFactory(mock: true).mock
        
        var body: some View {
            NavigationStack {
                TagsView(state: $store.state.tags) {
                    store.dispatch(action: $0)
                }
            }
        }
    }
    return ContainerView()
}
