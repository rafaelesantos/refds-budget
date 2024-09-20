import SwiftUI
import RefdsUI
import RefdsShared
import Domain
import Data
import Presentation

public struct ImportView: View {
    @Environment(\.privacyMode) private var privacyMode
    
    @Binding private var state: ImportStateProtocol?
    private let action: (ImportAction) -> Void
    
    @State private var categoryPrefix = 3
    @State private var subscribeData = false
    
    public init(
        state: Binding<ImportStateProtocol?>,
        action: @escaping (ImportAction) -> Void
    ) {
        self._state = state
        self.action = action
    }
    
    private var bindingError: Binding<RefdsBudgetError?> {
        Binding {
            state?.error
        } set: { error in
            state?.error = error
        }
    }
    
    public var body: some View {
        List {
            sectionTransactions
            sectionCategories
            sectionImport
        }
        .navigationTitle(String.localizable(by: .importNavigationTitle).capitalized)
        .refdsToast(item: bindingError)
    }
    
    @ViewBuilder
    private var sectionTransactions: some View {
        if let state = state {
            RefdsSection {
                VStack {
                    RefdsText(
                        .localizable(by: .importTotalValue).uppercased(),
                        style: .footnote,
                        color: .secondary,
                        weight: .bold
                    )
                    
                    let amount = state.model.transactions.map { $0.amount }.reduce(.zero, +)
                    let budget = state.model.budgets.map { $0.amount }.reduce(.zero, +)
                    
                    RefdsText(
                        amount.currency(),
                        style: .largeTitle,
                        weight: .black
                    )
                    .refdsRedacted(if: privacyMode)
                    
                    RefdsText(
                        budget.currency(),
                        style: .callout,
                        color: .accentColor,
                        weight: .bold
                    )
                    .refdsRedacted(if: privacyMode)
                    
                    Divider()
                        .padding(.top)
                        .padding(.trailing, -40)
                        .padding(.leading, -15)
                }
                .frame(maxWidth: .infinity)
                .padding([.top, .horizontal])
                .padding(.bottom, -10)
                
                HStack {
                    RefdsText(.localizable(by: .importTransactionsAmount))
                    Spacer(minLength: .zero)
                    RefdsText(state.model.transactions.count.asString, color: .secondary)
                }
                .listRowSeparator(.hidden, edges: .top)
                
                HStack {
                    RefdsText(.localizable(by: .importPeriod))
                    Spacer(minLength: .zero)
                    let startDate = state.model.transactions.min(by: { $0.date < $1.date })?.date.asString(withDateFormat: .custom("MMMM yyyy")).capitalized ?? ""
                    let endDate = state.model.transactions.max(by: { $0.date < $1.date })?.date.asString(withDateFormat: .custom("MMMM yyyy")).capitalized ?? ""
                    RefdsText(startDate + " - " + endDate, color: .secondary)
                }
            } header: {
                RefdsText(
                    .localizable(by: .transactionNavigationTitle),
                    style: .footnote,
                    color: .secondary
                )
            }
        }
    }
    
    @ViewBuilder
    private var sectionCategories: some View {
        if let state = state {
            RefdsSection {
                let budgets = Dictionary(grouping: state.model.budgets, by: { $0.category }).values
                let flatBudgets: [BudgetModel] = budgets.compactMap { budget in
                    guard let lastBudget = budget.last else { return nil }
                    return BudgetModel(
                        amount: budget.map { $0.amount }.reduce(.zero, +),
                        category: lastBudget.category,
                        date: lastBudget.date,
                        id: lastBudget.id,
                        message: budget.reversed().map {
                            $0.date.asString(withDateFormat: .custom("MMMM yyyy")).capitalized
                        }.joined(separator: " • ")
                    )
                }.sorted(by: { $0.amount > $1.amount })
                
                ForEach(flatBudgets.prefix(categoryPrefix).indices, id: \.self) {
                    let budget = flatBudgets[$0]
                    if let category = state.model.categories.first(where: { $0.id == budget.category }),
                    let icon = RefdsIconSymbol(rawValue: category.icon) {
                        HStack(spacing: .medium) {
                            ZStack(alignment: .topTrailing) {
                                RefdsIcon(
                                    icon,
                                    color: Color(hex: category.color),
                                    size: .medium
                                )
                                .frame(width: .medium, height: .medium)
                                .padding(10)
                                .background(Color(hex: category.color).opacity(0.2))
                                .clipShape(.rect(cornerRadius: .cornerRadius))
                                
                                RefdsText(
                                    (budget.message?.components(separatedBy: " • ").count ?? .zero).asString,
                                    style: .system(size: 9),
                                    color: .white,
                                    weight: .bold
                                )
                                .frame(width: 20, height: 20)
                                .background(Color.accentColor)
                                .clipShape(.circle)
                                .padding(.vertical, -5)
                                .padding(.horizontal, -8)
                            }
                            
                            VStack(alignment: .leading, spacing: .extraSmall) {
                                HStack {
                                    RefdsText(category.name.capitalized)
                                    Spacer(minLength: .zero)
                                    
                                    RefdsText(
                                        budget.amount.currency(),
                                        style: .callout
                                    )
                                    .refdsRedacted(if: privacyMode)
                                }
                                
                                if let message = budget.message {
                                    RefdsText(message, style: .footnote, color: .secondary, lineLimit: 2)
                                }
                            }
                        }
                    }
                }
                
                rowShowMoreCategories(for: flatBudgets.count)
            } header: {
                RefdsText(
                    .localizable(by: .categoriesNavigationTitle),
                    style: .footnote,
                    color: .secondary
                )
            }
        }
    }
    
    @ViewBuilder
    private var sectionImport: some View {
        if let state = state {
            RefdsSection { } header: {
                Divider()
            } footer: {
                VStack(spacing: .medium) {
                    RefdsToggle(isOn: $subscribeData, style: .checkmark) {
                        RefdsText(
                            .localizable(by: .importWarning),
                            style: .footnote,
                            color: .secondary
                        )
                    }
                    .disabled(state.isLoading)
                    
                    if state.isLoading {
                        RefdsLoadingView(color: .accentColor)
                            .padding(.top, 30)
                            .padding(.bottom, 40)
                    } else {
                        RefdsButton(.localizable(by: .importImportHeader), isDisable: !subscribeData) {
                            action(.save)
                        }
                        .padding(.bottom, 40)
                    }
                }
                .padding(.horizontal, -20)
            }
        }
    }
    
    @ViewBuilder
    private func rowShowMoreCategories(for amount: Int) -> some View {
        if amount > 3 {
            let isMax = categoryPrefix == amount
            RefdsButton {
                withAnimation {
                    categoryPrefix = isMax ? 3 : amount
                }
            } label: {
                HStack(spacing: .medium) {
                    RefdsText(isMax ? .localizable(by: .importShowLessCategories) : .localizable(by: .importShowMoreCategories))
                    Spacer(minLength: .zero)
                    RefdsText((isMax ? 3 : amount - 3).asString, color: .secondary)
                    RefdsIcon(isMax ? .chevronUp : .chevronDown, color: .placeholder)
                }
            }
        }
    }
}

#Preview {
    struct ContainerView: View {
        @StateObject private var store = StoreFactory.development
        
        var body: some View {
            NavigationStack {
                ImportView(state: $store.state.importState) {
                    store.dispatch(action: $0)
                }
            }
        }
    }
    return ContainerView()
}
