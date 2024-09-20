import WidgetKit
import SwiftUI
import RefdsUI
import RefdsShared
import UserInterface
import Domain
import Presentation
import Mock

struct SystemSmallExpenseTrackerProvider: AppIntentTimelineProvider {
    private let presenter = RefdsBudgetIntentPresenter.shared
    
    func placeholder(in context: Context) -> SystemSmallExpenseTrackerEntry {
        let viewData = WidgetExpensesViewData(
            isFilterByDate: true,
            category: .localizable(by: .transactionsCategoriesAllSelected),
            tag: .localizable(by: .transactionsCategoriesAllSelected),
            status: .localizable(by: .transactionsCategoriesAllSelected),
            date: .current,
            spend: .zero,
            budget: .zero
        )
        return SystemSmallExpenseTrackerEntry(viewData: viewData)
    }

    func snapshot(for configuration: WidgetAppIntent, in context: Context) async -> SystemSmallExpenseTrackerEntry {
        let viewData = presenter.getWidgetExpensesViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: configuration.category,
            tag: configuration.tag,
            status: configuration.status
        )
        return SystemSmallExpenseTrackerEntry(viewData: viewData)
    }
    
    func timeline(for configuration: WidgetAppIntent, in context: Context) async -> Timeline<SystemSmallExpenseTrackerEntry> {
        let viewData = presenter.getWidgetExpensesViewData(
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

struct SystemSmallExpenseTrackerEntry: TimelineEntry {
    var date: Date = .current
    let viewData: WidgetExpensesViewDataProtocol
}

struct SystemSmallExpenseTrackerView: View {
    var entry: SystemSmallExpenseTrackerProvider.Entry
    
    var body: some View {
        UserInterface.SystemSmallExpenseTracker(viewData: entry.viewData)
            .widgetURL(
                ApplicationRouter.deeplinkURL(
                    scene: .home,
                    view: .none,
                    viewStates: []
                )
            )
    }
}

struct SystemSmallExpenseTracker: Widget {
    let kind: String = "SystemSmallExpenseTracker"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: WidgetAppIntent.self,
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
        viewData: WidgetExpensesViewDataMock()
    )
    SystemSmallExpenseTrackerEntry(
        viewData: WidgetExpensesViewDataMock()
    )
    SystemSmallExpenseTrackerEntry(
        viewData: WidgetExpensesViewDataMock()
    )
}
