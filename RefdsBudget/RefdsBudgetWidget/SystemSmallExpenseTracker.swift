import WidgetKit
import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetUI
import RefdsBudgetPresentation

struct SystemSmallExpenseTrackerProvider: AppIntentTimelineProvider {
    private let presenter = RefdsBudgetWidgetPresenter()
    
    func placeholder(in context: Context) -> SystemSmallExpenseTrackerEntry {
        let viewData = presenter.getSystemSmallExpenseTrackerViewData(isFilterByDate: true)
        return SystemSmallExpenseTrackerEntry(viewData: viewData)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SystemSmallExpenseTrackerEntry {
        let viewData = presenter.getSystemSmallExpenseTrackerViewData(isFilterByDate: configuration.isFilterByDate)
        return SystemSmallExpenseTrackerEntry(viewData: viewData)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SystemSmallExpenseTrackerEntry> {
        let viewData = presenter.getSystemSmallExpenseTrackerViewData(isFilterByDate: configuration.isFilterByDate)
        let entries: [SystemSmallExpenseTrackerEntry] = [
            SystemSmallExpenseTrackerEntry(viewData: viewData)
        ]
        return Timeline(entries: entries, policy: .never)
    }
}

struct SystemSmallExpenseTrackerEntry: TimelineEntry {
    var date: Date = .current
    let viewData: SystemSmallExpenseTrackerViewDataProtocol
}

struct SystemSmallExpenseTrackerView: View {
    var entry: SystemSmallExpenseTrackerProvider.Entry
    
    var body: some View {
        RefdsBudgetUI.SystemSmallExpenseTracker(viewData: entry.viewData)
    }
}

struct SystemSmallExpenseTracker: Widget {
    let kind: String = "SystemSmallExpenseTracker"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
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
        viewData: SystemSmallExpenseTrackerViewDataMock()
    )
    SystemSmallExpenseTrackerEntry(
        viewData: SystemSmallExpenseTrackerViewDataMock()
    )
    SystemSmallExpenseTrackerEntry(
        viewData: SystemSmallExpenseTrackerViewDataMock()
    )
}
