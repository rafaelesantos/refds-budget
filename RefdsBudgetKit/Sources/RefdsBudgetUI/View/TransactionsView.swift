import SwiftUI
import RefdsUI
import RefdsRedux
import RefdsShared
import RefdsBudgetDomain
import RefdsBudgetData
import RefdsBudgetPresentation

public struct TransactionsView: View {
    @Environment(\.applicationState) private var applicationState
    @Environment(\.itemNavigation) private var itemNavigation
    @Environment(\.privacyMode) private var privacyMode
    @Binding private var state: TransactionsStateProtocol
    
    @State private var editMode: EditMode = .inactive
    @State private var multiSelection = Set<UUID>()
    @State private var showDocumentPicker = false
    @State private var privacyModeEditable = false
    
    private let action: (TransactionsAction) -> Void
    
    public init(
        state: Binding<TransactionsStateProtocol>,
        action: @escaping (TransactionsAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    public var body: some View {
        List(selection: $multiSelection) {
            sectionBalance
            sectionFilters
            sectionTransactions
            sectionPagination
        }
        .searchable(text: $state.searchText)
        .navigationTitle(navigationTitle)
        .onAppear { reloadData() }
        .refreshable { reloadData() }
        .environment(\.editMode, $editMode)
        .environment(\.privacyMode, privacyModeEditable)
        .onChange(of: booleans) { reloadData() }
        .onChange(of: state.paginationDaysAmount) { reloadData() }
        .onChange(of: state.date) { reloadData() }
        .onChange(of: state.searchText) { reloadData() }
        .onChange(of: setStrings) { reloadData() }
        .onChange(of: state.page) {
            if let lastOne = state.transactions.last?.last {
                state.transactions = [[lastOne]]
            }
            reloadData()
        }
        .toolbar { ToolbarItemGroup { moreButton } }
        .toolbar { ToolbarItem(placement: .bottomBar) { paginationView } }
        .fileImporter(
            isPresented: $showDocumentPicker,
            allowedContentTypes: [.item],
            onCompletion: handlerDocument(for:)
        )
        .refdsDismissesKeyboad()
        .refdsToast(item: $state.error)
        .refdsShareText(item: $state.shareText)
        .refdsShare(item: $state.share)
    }
    
    private var booleans: [Bool] {
        [
            state.isFilterEnable
        ]
    }
    
    private var setStrings: [Set<String>] {
        [
            state.selectedCategories,
            state.selectedTags,
            state.selectedStatus
        ]
    }
    
    private var navigationTitle: String {
        editMode.isEditing ? .localizable(by: .transactionEditNavigationTitle, with: multiSelection.count) :
        .localizable(by: .transactionNavigationTitle)
    }
    
    private func reloadData() {
        privacyModeEditable = privacyMode
        action(.fetchData)
    }
    
    private var bindingApplicationState: Binding<ApplicationStateProtocol> {
        Binding {
            applicationState?.wrappedValue ?? ApplicationState()
        } set: {
            applicationState?.wrappedValue = $0
        }
    }
    
    private var bindingItemNavigation: Binding<Int> {
        Binding {
            itemNavigation?.wrappedValue?.rawValue ?? ItemNavigation.home.rawValue
        } set: {
            if let item = ItemNavigation(rawValue: $0) {
                itemNavigation?.wrappedValue = item
            }
        }
    }
    
    private func handlerDocument(for result: Result<URL, Error>) {
        switch result {
        case let .success(url):
            Deeplink.shared.trigger(
                state: bindingApplicationState,
                itemNavigation: bindingItemNavigation,
                url: url
            )
        case .failure:
            state.error = .notFoundBudget
        }
    }
    
    @ViewBuilder
    private var sectionBalance: some View {
        if let balance = state.balance {
            RefdsSection {
                BalanceRowView(viewData: balance)
                addTransactionButton
            } header: {
                RefdsText(.localizable(by: .categoriesBalance), style: .footnote, color: .secondary)
            }
        }
    }
    
    private var sectionTransactions: some View {
        TransactionSectionsView(
            viewData: state.transactions,
            isLoading: state.isLoading
        ) {
            action(.fetchTransactionForEdit($0.id))
        } remove: { id in
            action(.removeTransaction(id))
        } resolve: { id in
            action(.updateStatus(id))
        }
    }
    
    private var addTransactionButton: some View {
        RefdsButton { action(.addTransaction(nil)) } label: {
            HStack {
                RefdsText(
                    .localizable(by: .transactionsAddTransaction),
                    style: .callout,
                    color: .accentColor
                )
                Spacer()
                RefdsIcon(
                    .chevronRight,
                    color: .secondary.opacity(0.5),
                    style: .callout
                )
            }
        }
    }
    
    private var moreButton: some View {
        Menu {
            RefdsText(.localizable(by: .transactionsMoreMenuHeader, with: multiSelection.count))
            
            Divider()
            
            BudgetLabel(
                title: .transactionsNewTransactions,
                icon: .plus,
                isProFeature: false
            ) {
                action(.addTransaction(nil))
            }
            
            BudgetLabel(
                title: editMode.isEditing ? .transactionsOptionsSelectDone : .transactionsOptionsSelect,
                icon: editMode.isEditing ? .circle : .checkmarkCircle,
                isProFeature: false
            ) {
                editMode.toggle()
            }
            
            BudgetLabel(
                title: .importNavigationTitle,
                icon: .trayAndArrowDownFill,
                isProFeature: false
            ) {
                showDocumentPicker.toggle()
            }
            
            if !multiSelection.isEmpty {
                BudgetLabel(
                    title: .transactionsRemoveTransactions,
                    icon: .trashFill,
                    isProFeature: false
                ) {
                    action(.removeTransactions(multiSelection))
                    if editMode.isEditing {
                        editMode.toggle()
                    }
                }
            }
            
            Divider()
            
            if !state.transactions.isEmpty {
                let ids = multiSelection.isEmpty ? Set(state.transactions.flatMap { $0 }.map { $0.id }) : multiSelection
                BudgetLabel(
                    title: .transactionsShare,
                    icon: .iphoneSizes,
                    isProFeature: true
                ) {
                    action(.share(ids))
                    if editMode.isEditing {
                        editMode.toggle()
                    }
                }
                
                BudgetLabel(
                    title: .transactionsShareText,
                    icon: .ellipsisMessageFill,
                    isProFeature: true
                ) {
                    action(.shareText(ids))
                    if editMode.isEditing {
                        editMode.toggle()
                    }
                }
            }
            
            BudgetLabel(
                title: .settingsRowPrivacyMode,
                icon: privacyModeEditable ? .eyeSlashFill : .eyeFill,
                isProFeature: true
            ) {
                privacyModeEditable.toggle()
            }
        } label: {
            RefdsIcon(
                .ellipsisCircleFill,
                color: .accentColor,
                size: 18,
                weight: .bold,
                renderingMode: .hierarchical
            )
        }
    }
    
    @ViewBuilder
    private var sectionFilters: some View {
        Menu {
            RefdsButton {
                withAnimation { state.isFilterEnable.toggle() }
            } label: {
                Label(
                    String.localizable(by: .transactionsFilterByDate),
                    systemImage: state.isFilterEnable ? RefdsIconSymbol.checkmark.rawValue : ""
                )
            }
            
            selectCategoryRowView
            selectTagRowView
            selectStatusRowView
        } label: {
            HStack {
                RefdsText(.localizable(by: .categoriesFilter), style: .callout)
                Spacer()
                RefdsText(3.asString, style: .callout, color: .secondary)
                RefdsIcon(.chevronUpChevronDown, color: .secondary.opacity(0.5), style: .callout)
            }
        }
        
        if state.isFilterEnable {
            DateRowView(date: $state.date)
        }
        
        let words = Array(state.selectedStatus) + Array(state.selectedTags) + Array(state.selectedCategories)
        let sentence = words.joined(separator: " • ").uppercased()
        
        if !sentence.isEmpty {
            HStack(spacing: .padding(.medium)) {
                RefdsText(sentence, style: .footnote, color: .secondary)
                Spacer(minLength: .zero)
                RefdsButton {
                    withAnimation {
                        state.selectedTags = []
                        state.selectedCategories = []
                        state.selectedStatus = []
                    }
                } label: {
                    RefdsIcon(
                        .xmarkCircleFill,
                        color: .secondary.opacity(0.8),
                        size: 18,
                        weight: .bold,
                        renderingMode: .hierarchical
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    @ViewBuilder
    private var selectCategoryRowView: some View {
        if !state.categories.isEmpty {
            SelectMenuRowView(
                header: .transactionsCategoriesFilterHeader,
                icon: .squareStack3dForwardDottedlineFill,
                title: .categoriesNavigationTitle,
                data: state.categories,
                selectedData: $state.selectedCategories
            )
        }
    }
    
    @ViewBuilder
    private var selectTagRowView: some View {
        if !state.tags.isEmpty {
            SelectMenuRowView(
                header: .tagsMenuSelectHeader,
                icon: .tagFill,
                title: .tagsNavigationTitle,
                data: state.tags,
                selectedData: $state.selectedTags
            )
        }
    }
    
    @ViewBuilder
    private var selectStatusRowView: some View{
        let status: [TransactionStatus] = [.pending, .cleared]
        SelectMenuRowView(
            header: .addTransactionStatusSelect,
            icon: .listDashHeaderRectangle,
            title: .addTransactionStatusHeader,
            data: status.map { $0.description },
            selectedData: $state.selectedStatus
        )
    }
    
    private var sectionPagination: some View {
        RefdsSection {
            Picker(selection: $state.paginationDaysAmount) {
                let daysAmount = paginationDays
                ForEach(daysAmount.indices, id: \.self) {
                    let day = daysAmount[$0]
                    RefdsText(getPaginationDay(for: day))
                        .tag(day)
                }
            } label: {
                RefdsText(
                    .localizable(by: .transactionsPaginationDaysAmount),
                    style: .callout
                )
            }
            .tint(.secondary)
        } header: {
            RefdsText(
                .localizable(by: .transactionsPaginationHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    @ViewBuilder
    private var paginationView: some View {
        RefdsPagination(
            currentPage: $state.page,
            color: .accentColor,
            canChangeToNextPage: { state.canChangePage }
        )
    }
    
    private var paginationDays: [Int] {
        var daysAmount = [1, 2, 5]
        if let days = state.date.days {
            daysAmount += [days / 2, days]
        }
        return daysAmount
    }
    
    private func getPaginationDay(for day: Int) -> String {
        guard let days = state.date.days else { return "" }
        switch day {
        case 1: return .localizable(by: .transactionsPaginationDay, with: day)
        case 2, 5: return .localizable(by: .transactionsPaginationDays, with: day)
        case days / 2: return .localizable(by: .transactionsPaginationHalfMonth)
        case days: return .localizable(by: .transactionsPaginationAllDays)
        default: return ""
        }
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = StoreFactory.development
        
        var body: some View {
            NavigationStack {
                TransactionsView(state: $store.state.transactionsState) {
                    store.dispatch(action: $0)
                }
            }
        }
    }
    return ContainerView()
}
