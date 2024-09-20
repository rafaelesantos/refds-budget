import WidgetKit
import SwiftUI
import RefdsUI
import RefdsShared
import UserInterface
import Domain
import Presentation
import Mock

struct SystemSmallExpenseProgressProvider: AppIntentTimelineProvider {
    private let presenter = RefdsBudgetIntentPresenter.shared
    
    func placeholder(in context: Context) -> SystemSmallExpenseProgressEntry {
        let viewData = WidgetExpensesViewData(
            isFilterByDate: true,
            category: .localizable(by: .transactionsCategoriesAllSelected),
            tag: .localizable(by: .transactionsCategoriesAllSelected),
            status: .localizable(by: .transactionsCategoriesAllSelected),
            date: .current,
            spend: .zero,
            budget: .zero
        )
        return SystemSmallExpenseProgressEntry(viewData: viewData)
    }

    func snapshot(for configuration: WidgetAppIntent, in context: Context) async -> SystemSmallExpenseProgressEntry {
        let viewData = presenter.getWidgetExpensesViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: configuration.category,
            tag: configuration.tag,
            status: configuration.status
        )
        return SystemSmallExpenseProgressEntry(viewData: viewData)
    }
    
    func timeline(for configuration: WidgetAppIntent, in context: Context) async -> Timeline<SystemSmallExpenseProgressEntry> {
        let viewData = presenter.getWidgetExpensesViewData(
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

struct SystemSmallExpenseProgressEntry: TimelineEntry {
    var date: Date = .current
    let viewData: WidgetExpensesViewDataProtocol
}

struct SystemSmallExpenseProgressView: View {
    var entry: SystemSmallExpenseProgressProvider.Entry
    
    var body: some View {
        UserInterface.SystemSmallExpenseProgress(viewData: entry.viewData)
            .widgetURL(
                ApplicationRouter.deeplinkURL(
                    scene: .home,
                    view: .none,
                    viewStates: []
                )
            )
    }
}

struct SystemSmallExpenseProgress: Widget {
    let kind: String = "SystemSmallExpenseProgress"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: WidgetAppIntent.self,
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
        viewData: WidgetExpensesViewDataMock()
    )
    SystemSmallExpenseProgressEntry(
        viewData: WidgetExpensesViewDataMock()
    )
    SystemSmallExpenseProgressEntry(
        viewData: WidgetExpensesViewDataMock()
    )
}
