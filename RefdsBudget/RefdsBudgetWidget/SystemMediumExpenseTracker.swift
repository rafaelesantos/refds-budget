import WidgetKit
import SwiftUI
import RefdsUI
import RefdsShared
import UserInterface
import Domain
import Presentation
import Mock

struct SystemMediumExpenseTrackerProvider: AppIntentTimelineProvider {
    private let presenter = RefdsBudgetIntentPresenter.shared
    
    func placeholder(in context: Context) -> SystemMediumExpenseTrackerEntry {
        let viewData = WidgetTransactionsViewData(
            isFilterByDate: true,
            category: .localizable(by: .transactionsCategoriesAllSelected),
            tag: .localizable(by: .transactionsCategoriesAllSelected),
            status: .localizable(by: .transactionsCategoriesAllSelected),
            date: .current,
            spend: .zero,
            budget: .zero,
            categories: [],
            transactions: [],
            amount: .zero
        )
        return SystemMediumExpenseTrackerEntry(viewData: viewData)
    }

    func snapshot(for configuration: WidgetAppIntent, in context: Context) async -> SystemMediumExpenseTrackerEntry {
        let viewData = presenter.getWidgetTransactionsViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: .localizable(by: .transactionsCategoriesAllSelected),
            tag: configuration.tag,
            status: configuration.status
        )
        return SystemMediumExpenseTrackerEntry(viewData: viewData)
    }
    
    func timeline(for configuration: WidgetAppIntent, in context: Context) async -> Timeline<SystemMediumExpenseTrackerEntry> {
        let viewData = presenter.getWidgetTransactionsViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: .localizable(by: .transactionsCategoriesAllSelected),
            tag: configuration.tag,
            status: configuration.status
        )
        let entries: [SystemMediumExpenseTrackerEntry] = [
            SystemMediumExpenseTrackerEntry(viewData: viewData)
        ]
        return Timeline(entries: entries, policy: .never)
    }
}

struct SystemMediumExpenseTrackerEntry: TimelineEntry {
    var date: Date = .current
    let viewData: WidgetTransactionsViewDataProtocol
}

struct SystemMediumExpenseTrackerView: View {
    var entry: SystemMediumExpenseTrackerProvider.Entry
    
    var body: some View {
        UserInterface.SystemMediumExpenseTracker(viewData: entry.viewData)
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
            intent: WidgetAppIntent.self,
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
