import WidgetKit
import SwiftUI
import RefdsUI
import RefdsShared
import UserInterface
import Domain
import Presentation
import Mock

struct SystemSmallTransactionsProvider: AppIntentTimelineProvider {
    private let presenter = RefdsBudgetIntentPresenter.shared
    
    func placeholder(in context: Context) -> SystemSmallTransactionsEntry {
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
        return SystemSmallTransactionsEntry(viewData: viewData)
    }

    func snapshot(for configuration: WidgetAppIntent, in context: Context) async -> SystemSmallTransactionsEntry {
        let viewData = presenter.getWidgetTransactionsViewData(
            isFilterByDate: configuration.isFilterByDate,
            category: configuration.category,
            tag: configuration.tag,
            status: configuration.status
        )
        return SystemSmallTransactionsEntry(viewData: viewData)
    }
    
    func timeline(for configuration: WidgetAppIntent, in context: Context) async -> Timeline<SystemSmallTransactionsEntry> {
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

struct SystemSmallTransactionsEntry: TimelineEntry {
    var date: Date = .current
    let viewData: WidgetTransactionsViewDataProtocol
}

struct SystemSmallTransactionsView: View {
    var entry: SystemSmallTransactionsProvider.Entry
    
    var body: some View {
        UserInterface.SystemSmallTransactions(viewData: entry.viewData)
            .widgetURL(
                ApplicationRouter.deeplinkURL(
                    scene: .transactions,
                    view: .none,
                    viewStates: [
                        .isDateFilter(entry.viewData.isFilterByDate),
                        .date(entry.viewData.date),
                        .selectedItems(Set([
                            entry.viewData.category,
                            entry.viewData.tag,
                            entry.viewData.status
                        ]))
                    ]
                )
            )
    }
}

struct SystemSmallTransactions: Widget {
    let kind: String = "SystemSmallTransactions"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: WidgetAppIntent.self,
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
