import WidgetKit
import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetUI
import RefdsBudgetDomain
import RefdsBudgetPresentation
import AppIntents

struct SystemSmallTransactionsProvider: AppIntentTimelineProvider {
    private let presenter = RefdsBudgetWidgetPresenter()
    
    func placeholder(in context: Context) -> SystemSmallTransactionsEntry {
        let viewData = WidgetTransactionsViewData(
            isFilterByDate: true,
            category: .localizable(by: .transactionsCategorieAllSelected),
            tag: .localizable(by: .transactionsCategorieAllSelected),
            date: .current,
            spend: .zero,
            budget: .zero,
            categories: [],
            transactions: [],
            amount: .zero
        )
        return SystemSmallTransactionsEntry(viewData: viewData)
    }

    func snapshot(for configuration: SystemSmallTransactionsAppIntent, in context: Context) async -> SystemSmallTransactionsEntry {
        let viewData = presenter.getWidgetTransactionsViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: configuration.category,
            tag: configuration.tag,
            status: configuration.status
        )
        return SystemSmallTransactionsEntry(viewData: viewData)
    }
    
    func timeline(for configuration: SystemSmallTransactionsAppIntent, in context: Context) async -> Timeline<SystemSmallTransactionsEntry> {
        let viewData = presenter.getWidgetTransactionsViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: configuration.category,
            tag: configuration.tag,
            status: configuration.status
        )
        let entries: [SystemSmallTransactionsEntry] = [
            SystemSmallTransactionsEntry(viewData: viewData)
        ]
        return Timeline(entries: entries, policy: .never)
    }
}

struct SystemSmallTransactionsAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "SystemSmallTransactionsAppIntent"
    static var description = IntentDescription("SystemSmallTransactionsAppIntent")

    @Parameter(title: "Filter by date", default: true)
    var isFilterByDate: Bool
    
    @Parameter(title: "Category", optionsProvider: CategoriesOptionsProvider())
    var category: String
    
    @Parameter(title: "Tag", optionsProvider: TagsOptionsProvider())
    var tag: String
    
    @Parameter(title: "Status", optionsProvider: StatusOptionsProvider())
    var status: String
    
    private struct CategoriesOptionsProvider: DynamicOptionsProvider {
        private let presenter: RefdsBudgetWidgetPresenterProtocol = RefdsBudgetWidgetPresenter()
        
        func defaultResult() async -> String? {
            .localizable(by: .transactionsCategorieAllSelected)
        }
        
        func results() async throws -> [String] {
            presenter.getCategories()
        }
    }
    
    private struct TagsOptionsProvider: DynamicOptionsProvider {
        private let presenter: RefdsBudgetWidgetPresenterProtocol = RefdsBudgetWidgetPresenter()
        
        func defaultResult() async -> String? {
            .localizable(by: .transactionsCategorieAllSelected)
        }
        
        func results() async throws -> [String] {
            presenter.getTags()
        }
    }
    
    private struct StatusOptionsProvider: DynamicOptionsProvider {
        private let presenter: RefdsBudgetWidgetPresenterProtocol = RefdsBudgetWidgetPresenter()
        
        func defaultResult() async -> String? {
            .localizable(by: .transactionsCategorieAllSelected)
        }
        
        func results() async throws -> [String] {
            let status: [TransactionStatus] = [.pending, .cleared]
            return status.map { $0.description } + [.localizable(by: .transactionsCategorieAllSelected)]
        }
    }
}

struct SystemSmallTransactionsEntry: TimelineEntry {
    var date: Date = .current
    let viewData: WidgetTransactionsViewDataProtocol
}

struct SystemSmallTransactionsView: View {
    var entry: SystemSmallTransactionsProvider.Entry
    
    var body: some View {
        RefdsBudgetUI.SystemSmallTransactions(viewData: entry.viewData)
            .widgetURL(
                Deeplink.url(
                    host: .openTransactions,
                    path: .addTransaction
                )
            )
    }
}

struct SystemSmallTransactions: Widget {
    let kind: String = "SystemSmallTransactions"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SystemSmallTransactionsAppIntent.self,
            provider: SystemSmallTransactionsProvider()
        ) { entry in
            SystemSmallTransactionsView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName(String.localizable(by: .widgetTitleSystemSmallTransactions))
        .description(String.localizable(by: .widgetDescriptionSystemSmallTransactions))
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    SystemSmallTransactions()
} timeline: {
    SystemSmallTransactionsEntry(
        viewData: WidgetTransactionsViewDataMock()
    )
    SystemSmallTransactionsEntry(
        viewData: WidgetTransactionsViewDataMock()
    )
    SystemSmallTransactionsEntry(
        viewData: WidgetTransactionsViewDataMock()
    )
}
