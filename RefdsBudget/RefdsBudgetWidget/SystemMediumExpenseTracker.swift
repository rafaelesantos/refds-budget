import WidgetKit
import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetUI
import RefdsBudgetDomain
import RefdsBudgetPresentation
import AppIntents

struct SystemMediumExpenseTrackerProvider: AppIntentTimelineProvider {
    private let presenter = RefdsBudgetIntentPresenter.shared
    
    func placeholder(in context: Context) -> SystemMediumExpenseTrackerEntry {
        let viewData = WidgetTransactionsViewData(
            isFilterByDate: true,
            category: .localizable(by: .transactionsCategorieAllSelected),
            tag: .localizable(by: .transactionsCategorieAllSelected),
            status: .localizable(by: .transactionsCategorieAllSelected),
            date: .current,
            spend: .zero,
            budget: .zero,
            categories: [],
            transactions: [],
            amount: .zero
        )
        return SystemMediumExpenseTrackerEntry(viewData: viewData)
    }

    func snapshot(for configuration: SystemMediumExpenseTrackerAppIntent, in context: Context) async -> SystemMediumExpenseTrackerEntry {
        let viewData = presenter.getWidgetTransactionsViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: .localizable(by: .transactionsCategorieAllSelected),
            tag: configuration.tag,
            status: configuration.status
        )
        return SystemMediumExpenseTrackerEntry(viewData: viewData)
    }
    
    func timeline(for configuration: SystemMediumExpenseTrackerAppIntent, in context: Context) async -> Timeline<SystemMediumExpenseTrackerEntry> {
        let viewData = presenter.getWidgetTransactionsViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: .localizable(by: .transactionsCategorieAllSelected),
            tag: configuration.tag,
            status: configuration.status
        )
        let entries: [SystemMediumExpenseTrackerEntry] = [
            SystemMediumExpenseTrackerEntry(viewData: viewData)
        ]
        return Timeline(entries: entries, policy: .never)
    }
}

struct SystemMediumExpenseTrackerAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "SystemMediumExpenseTrackerAppIntent"
    static var description = IntentDescription("SystemMediumExpenseTrackerAppIntent")

    @Parameter(title: "Filter by date", default: true)
    var isFilterByDate: Bool
    
    @Parameter(title: "Tag", optionsProvider: TagsOptionsProvider())
    var tag: String
    
    @Parameter(title: "Status", optionsProvider: StatusOptionsProvider())
    var status: String
    
    private struct TagsOptionsProvider: DynamicOptionsProvider {
        private let presenter: RefdsBudgetIntentPresenterProtocol = RefdsBudgetIntentPresenter.shared
        
        func defaultResult() async -> String? {
            .localizable(by: .transactionsCategorieAllSelected)
        }
        
        func results() async throws -> [String] {
            presenter.getTags()
        }
    }
    
    private struct StatusOptionsProvider: DynamicOptionsProvider {
        private let presenter: RefdsBudgetIntentPresenterProtocol = RefdsBudgetIntentPresenter.shared
        
        func defaultResult() async -> String? {
            .localizable(by: .transactionsCategorieAllSelected)
        }
        
        func results() async throws -> [String] {
            let status: [TransactionStatus] = [.pending, .cleared]
            return status.map { $0.description } + [.localizable(by: .transactionsCategorieAllSelected)]
        }
    }
}

struct SystemMediumExpenseTrackerEntry: TimelineEntry {
    var date: Date = .current
    let viewData: WidgetTransactionsViewDataProtocol
}

struct SystemMediumExpenseTrackerView: View {
    var entry: SystemMediumExpenseTrackerProvider.Entry
    
    var body: some View {
        RefdsBudgetUI.SystemMediumExpenseTracker(viewData: entry.viewData)
            .widgetURL(
                ApplicationRouter.deeplinkURL(
                    scene: .home,
                    view: .none,
                    viewStates: []
                )
            )
    }
}

struct SystemMediumExpenseTracker: Widget {
    let kind: String = "SystemMediumExpenseTracker"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SystemMediumExpenseTrackerAppIntent.self,
            provider: SystemMediumExpenseTrackerProvider()
        ) { entry in
            SystemMediumExpenseTrackerView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName(String.localizable(by: .widgetTitleSystemSmallExpanseTracker))
        .description(String.localizable(by: .widgetDescriptionSystemSmallExpanseTracker))
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    SystemMediumExpenseTracker()
} timeline: {
    SystemMediumExpenseTrackerEntry(
        viewData: WidgetTransactionsViewDataMock()
    )
    SystemMediumExpenseTrackerEntry(
        viewData: WidgetTransactionsViewDataMock()
    )
    SystemMediumExpenseTrackerEntry(
        viewData: WidgetTransactionsViewDataMock()
    )
}
