import WidgetKit
import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetUI
import RefdsBudgetDomain
import RefdsBudgetPresentation
import AppIntents

struct SystemLargeExpenseTrackerProvider: AppIntentTimelineProvider {
    private let presenter = RefdsBudgetIntentPresenter.shared
    
    func placeholder(in context: Context) -> SystemLargeExpenseTrackerEntry {
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
        return SystemLargeExpenseTrackerEntry(viewData: viewData)
    }

    func snapshot(for configuration: SystemLargeExpenseTrackerAppIntent, in context: Context) async -> SystemLargeExpenseTrackerEntry {
        let viewData = presenter.getWidgetTransactionsViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: .localizable(by: .transactionsCategorieAllSelected),
            tag: configuration.tag,
            status: configuration.status
        )
        return SystemLargeExpenseTrackerEntry(viewData: viewData)
    }
    
    func timeline(for configuration: SystemLargeExpenseTrackerAppIntent, in context: Context) async -> Timeline<SystemLargeExpenseTrackerEntry> {
        let viewData = presenter.getWidgetTransactionsViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: .localizable(by: .transactionsCategorieAllSelected),
            tag: configuration.tag,
            status: configuration.status
        )
        let entries: [SystemLargeExpenseTrackerEntry] = [
            SystemLargeExpenseTrackerEntry(viewData: viewData)
        ]
        return Timeline(entries: entries, policy: .never)
    }
}

struct SystemLargeExpenseTrackerAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "SystemLargeExpenseTrackerAppIntent"
    static var description = IntentDescription("SystemLargeExpenseTrackerAppIntent")

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

struct SystemLargeExpenseTrackerEntry: TimelineEntry {
    var date: Date = .current
    let viewData: WidgetTransactionsViewDataProtocol
}

struct SystemLargeExpenseTrackerView: View {
    var entry: SystemLargeExpenseTrackerProvider.Entry
    
    var body: some View {
        RefdsBudgetUI.SystemLargeExpenseTracker(viewData: entry.viewData)
            .widgetURL(
                Deeplink.url(
                    host: .openHome,
                    path: .none
                )
            )
    }
}

struct SystemLargeExpenseTracker: Widget {
    let kind: String = "SystemLargeExpenseTracker"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SystemLargeExpenseTrackerAppIntent.self,
            provider: SystemLargeExpenseTrackerProvider()
        ) { entry in
            SystemLargeExpenseTrackerView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName(String.localizable(by: .widgetTitleSystemSmallExpanseTracker))
        .description(String.localizable(by: .widgetDescriptionSystemSmallExpanseTracker))
        .supportedFamilies([.systemLarge])
    }
}

#Preview(as: .systemLarge) {
    SystemLargeExpenseTracker()
} timeline: {
    SystemLargeExpenseTrackerEntry(
        viewData: WidgetTransactionsViewDataMock()
    )
    SystemLargeExpenseTrackerEntry(
        viewData: WidgetTransactionsViewDataMock()
    )
    SystemLargeExpenseTrackerEntry(
        viewData: WidgetTransactionsViewDataMock()
    )
}
