import WidgetKit
import AppIntents
import RefdsBudgetResource

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    @Parameter(title: "Filter by date", default: true)
    var isFilterByDate: Bool
}
