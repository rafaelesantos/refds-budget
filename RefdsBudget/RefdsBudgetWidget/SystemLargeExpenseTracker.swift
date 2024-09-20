import WidgetKit
import SwiftUI
import RefdsUI
import RefdsShared
import UserInterface
import Domain
import Presentation
import Mock

struct SystemLargeExpenseTrackerProvider: AppIntentTimelineProvider {
    private let presenter = RefdsBudgetIntentPresenter.shared
    
    func placeholder(in context: Context) -> SystemLargeExpenseTrackerEntry {
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
        return SystemLargeExpenseTrackerEntry(viewData: viewData)
    }

    func snapshot(for configuration: WidgetAppIntent, in context: Context) async -> SystemLargeExpenseTrackerEntry {
        let viewData = presenter.getWidgetTransactionsViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: .localizable(by: .transactionsCategoriesAllSelected),
            tag: configuration.tag,
            status: configuration.status
        )
        return SystemLargeExpenseTrackerEntry(viewData: viewData)
    }
    
    func timeline(for configuration: WidgetAppIntent, in context: Context) async -> Timeline<SystemLargeExpenseTrackerEntry> {
        let viewData = presenter.getWidgetTransactionsViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: .localizable(by: .transactionsCategoriesAllSelected),
            tag: configuration.tag,
            status: configuration.status
        )
        let entries: [SystemLargeExpenseTrackerEntry] = [
            SystemLargeExpenseTrackerEntry(viewData: viewData)
        ]
        return Timeline(entries: entries, policy: .never)
    }
}

struct SystemLargeExpenseTrackerEntry: TimelineEntry {
    var date: Date = .current
    let viewData: WidgetTransactionsViewDataProtocol
}

struct SystemLargeExpenseTrackerView: View {
    var entry: SystemLargeExpenseTrackerProvider.Entry
    
    var body: some View {
        UserInterface.SystemLargeExpenseTracker(viewData: entry.viewData)
            .widgetURL(
                ApplicationRouter.deeplinkURL(
                    scene: .home,
                    view: .none,
                    viewStates: []
                )
            )
    }
}

struct SystemLargeExpenseTracker: Widget {
    let kind: String = "SystemLargeExpenseTracker"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: WidgetAppIntent.self,
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
