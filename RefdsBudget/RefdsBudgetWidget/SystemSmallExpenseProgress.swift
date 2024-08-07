import WidgetKit
import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetUI
import RefdsBudgetDomain
import RefdsBudgetPresentation
import AppIntents

struct SystemSmallExpenseProgressProvider: AppIntentTimelineProvider {
    private let presenter = RefdsBudgetIntentPresenter.shared
    
    func placeholder(in context: Context) -> SystemSmallExpenseProgressEntry {
        let viewData = WidgetExpenseTrackerViewData(
            isFilterByDate: true,
            category: .localizable(by: .transactionsCategorieAllSelected),
            tag: .localizable(by: .transactionsCategorieAllSelected),
            status: .localizable(by: .transactionsCategorieAllSelected),
            date: .current,
            spend: .zero,
            budget: .zero
        )
        return SystemSmallExpenseProgressEntry(viewData: viewData)
    }

    func snapshot(for configuration: SystemSmallExpenseProgressAppIntent, in context: Context) async -> SystemSmallExpenseProgressEntry {
        let viewData = presenter.getWidgetExpenseTrackerViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: configuration.category,
            tag: configuration.tag,
            status: configuration.status
        )
        return SystemSmallExpenseProgressEntry(viewData: viewData)
    }
    
    func timeline(for configuration: SystemSmallExpenseProgressAppIntent, in context: Context) async -> Timeline<SystemSmallExpenseProgressEntry> {
        let viewData = presenter.getWidgetExpenseTrackerViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: configuration.category,
            tag: configuration.tag,
            status: configuration.status
        )
        let entries: [SystemSmallExpenseProgressEntry] = [
            SystemSmallExpenseProgressEntry(viewData: viewData)
        ]
        return Timeline(entries: entries, policy: .never)
    }
}

struct SystemSmallExpenseProgressAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "SystemSmallExpenseProgressAppIntent"
    static var description = IntentDescription("SystemSmallExpenseProgressAppIntent")

    @Parameter(title: "Filter by date", default: true)
    var isFilterByDate: Bool
    
    @Parameter(title: "Category", optionsProvider: CategoriesOptionsProvider())
    var category: String
    
    @Parameter(title: "Tag", optionsProvider: TagsOptionsProvider())
    var tag: String
    
    @Parameter(title: "Status", optionsProvider: StatusOptionsProvider())
    var status: String
    
    private struct CategoriesOptionsProvider: DynamicOptionsProvider {
        private let presenter: RefdsBudgetIntentPresenterProtocol = RefdsBudgetIntentPresenter.shared
        
        func defaultResult() async -> String? {
            .localizable(by: .transactionsCategorieAllSelected)
        }
        
        func results() async throws -> [String] {
            presenter.getCategories()
        }
    }
    
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

struct SystemSmallExpenseProgressEntry: TimelineEntry {
    var date: Date = .current
    let viewData: WidgetExpenseTrackerViewDataProtocol
}

struct SystemSmallExpenseProgressView: View {
    var entry: SystemSmallExpenseProgressProvider.Entry
    
    var body: some View {
        RefdsBudgetUI.SystemSmallExpenseProgress(viewData: entry.viewData)
            .widgetURL(
                Deeplink.url(
                    host: .openHome,
                    path: .none
                )
            )
    }
}

struct SystemSmallExpenseProgress: Widget {
    let kind: String = "SystemSmallExpenseProgress"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SystemSmallExpenseProgressAppIntent.self,
            provider: SystemSmallExpenseProgressProvider()
        ) { entry in
            SystemSmallExpenseProgressView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName(String.localizable(by: .widgetTitleSystemSmallExpanseTracker))
        .description(String.localizable(by: .widgetDescriptionSystemSmallExpanseTracker))
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    SystemSmallExpenseProgress()
} timeline: {
    SystemSmallExpenseProgressEntry(
        viewData: WidgetExpenseTrackerViewDataMock()
    )
    SystemSmallExpenseProgressEntry(
        viewData: WidgetExpenseTrackerViewDataMock()
    )
    SystemSmallExpenseProgressEntry(
        viewData: WidgetExpenseTrackerViewDataMock()
    )
}
