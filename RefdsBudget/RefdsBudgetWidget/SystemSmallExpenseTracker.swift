import WidgetKit
import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetUI
import RefdsBudgetDomain
import RefdsBudgetPresentation
import AppIntents

struct SystemSmallExpenseTrackerProvider: AppIntentTimelineProvider {
    private let presenter = RefdsBudgetWidgetPresenter()
    
    func placeholder(in context: Context) -> SystemSmallExpenseTrackerEntry {
        let viewData = WidgetExpenseTrackerViewData(
            isFilterByDate: true,
            category: .localizable(by: .transactionsCategorieAllSelected),
            tag: .localizable(by: .transactionsCategorieAllSelected),
            date: .current,
            spend: .zero,
            budget: .zero
        )
        return SystemSmallExpenseTrackerEntry(viewData: viewData)
    }

    func snapshot(for configuration: SystemSmallExpenseTrackerAppIntent, in context: Context) async -> SystemSmallExpenseTrackerEntry {
        let viewData = presenter.getWidgetExpenseTrackerViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: configuration.category,
            tag: configuration.tag,
            status: configuration.status
        )
        return SystemSmallExpenseTrackerEntry(viewData: viewData)
    }
    
    func timeline(for configuration: SystemSmallExpenseTrackerAppIntent, in context: Context) async -> Timeline<SystemSmallExpenseTrackerEntry> {
        let viewData = presenter.getWidgetExpenseTrackerViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: configuration.category,
            tag: configuration.tag,
            status: configuration.status
        )
        let entries: [SystemSmallExpenseTrackerEntry] = [
            SystemSmallExpenseTrackerEntry(viewData: viewData)
        ]
        return Timeline(entries: entries, policy: .never)
    }
}

struct SystemSmallExpenseTrackerAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "SystemSmallExpenseTrackerAppIntent"
    static var description = IntentDescription("SystemSmallExpenseTrackerAppIntent")

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

struct SystemSmallExpenseTrackerEntry: TimelineEntry {
    var date: Date = .current
    let viewData: WidgetExpenseTrackerViewDataProtocol
}

struct SystemSmallExpenseTrackerView: View {
    var entry: SystemSmallExpenseTrackerProvider.Entry
    
    var body: some View {
        RefdsBudgetUI.SystemSmallExpenseTracker(viewData: entry.viewData)
            .widgetURL(
                Deeplink.url(
                    host: .openHome,
                    path: .none
                )
            )
    }
}

struct SystemSmallExpenseTracker: Widget {
    let kind: String = "SystemSmallExpenseTracker"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SystemSmallExpenseTrackerAppIntent.self,
            provider: SystemSmallExpenseTrackerProvider()
        ) { entry in
            SystemSmallExpenseTrackerView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName(String.localizable(by: .widgetTitleSystemSmallExpanseTracker))
        .description(String.localizable(by: .widgetDescriptionSystemSmallExpanseTracker))
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    SystemSmallExpenseTracker()
} timeline: {
    SystemSmallExpenseTrackerEntry(
        viewData: WidgetExpenseTrackerViewDataMock()
    )
    SystemSmallExpenseTrackerEntry(
        viewData: WidgetExpenseTrackerViewDataMock()
    )
    SystemSmallExpenseTrackerEntry(
        viewData: WidgetExpenseTrackerViewDataMock()
    )
}
