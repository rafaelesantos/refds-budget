import WidgetKit
import SwiftUI
import RefdsUI
import RefdsShared
import UserInterface
import Domain
import Presentation
import Mock

struct RemainingLockScreenProvider: TimelineProvider {
    private let presenter = RefdsBudgetIntentPresenter.shared
    
    func placeholder(in context: Context) -> RemainingLockScreenEntry {
        let viewData = WidgetExpensesViewData(
            isFilterByDate: true,
            category: .localizable(by: .transactionsCategoriesAllSelected),
            tag: .localizable(by: .transactionsCategoriesAllSelected),
            status: .localizable(by: .transactionsCategoriesAllSelected),
            date: .current,
            spend: .zero,
            budget: .zero
        )
        return RemainingLockScreenEntry(viewData: viewData)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RemainingLockScreenEntry) -> Void) {
        let viewData = presenter.getWidgetExpensesViewData(
            isFilterByDate: true,
            category: .localizable(by: .transactionsCategoriesAllSelected),
            tag: .localizable(by: .transactionsCategoriesAllSelected),
            status: .localizable(by: .transactionsCategoriesAllSelected)
        )
        completion(RemainingLockScreenEntry(viewData: viewData))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<RemainingLockScreenEntry>) -> Void) {
        let viewData = presenter.getWidgetExpensesViewData(
            isFilterByDate: true,
            category: .localizable(by: .transactionsCategoriesAllSelected),
            tag: .localizable(by: .transactionsCategoriesAllSelected),
            status: .localizable(by: .transactionsCategoriesAllSelected)
        )
        let entries: [RemainingLockScreenEntry] = [
            RemainingLockScreenEntry(viewData: viewData)
        ]
        completion(Timeline(entries: entries, policy: .never))
    }
}

struct RemainingLockScreenEntry: TimelineEntry {
    var date: Date = .current
    let viewData: WidgetExpensesViewDataProtocol
}

struct RemainingLockScreenView: View {
    @Environment(\.widgetFamily) var family
    var entry: RemainingLockScreenProvider.Entry
    
    var body: some View {
        switch family {
        case .accessoryCircular: RemainingAccessoryCircularLockScreenView(viewData: entry.viewData)
        case .accessoryRectangular: RemainingAccessoryRectangularLockScreenView(viewData: entry.viewData)
        default: EmptyView()
        }
    }
}

struct RemainingAccessoryCircularLockScreenView: View {
    var viewData: WidgetExpensesViewDataProtocol
    
    var body: some View {
        ViewThatFits {
            Gauge(
                value: viewData.percent,
                in: 0...1,
                label: {
                    Image(systemName: "dollarsign.square.fill")
                        .symbolRenderingMode(.hierarchical)
                        .scaleEffect(1.4)
                },
                currentValueLabel: { 
                    Text((1 - viewData.percent).percent())
                        .bold()
                        .scaleEffect(0.7)
                }
            )
            .gaugeStyle(.accessoryCircular)
        }
        .widgetURL(
            ApplicationRouter.deeplinkURL(
                scene: .home,
                view: .none,
                viewStates: []
            )
        )
    }
}

struct RemainingAccessoryRectangularLockScreenView: View {
    var viewData: WidgetExpensesViewDataProtocol
    
    var body: some View {
        ViewThatFits {
            VStack(alignment: .leading, spacing: .zero) {
                HStack(spacing: 10) {
                    Text(viewData.date.asString(withDateFormat: .custom("MMMM, yyyy")).uppercased())
                        .font(.footnote)
                    RefdsScaleProgressView(.lockScreen, riskColor: viewData.percent.riskColor, size: 20)
                }
                Spacer(minLength: .zero)
                Text(viewData.remaining.currency())
                    .font(.system(size: 25))
                    .bold()
                    .minimumScaleFactor(0.5)
                Spacer(minLength: .zero)
                HStack(spacing: 10) {
                    Gauge(value: viewData.percent, in: 0...1) { EmptyView() }
                        .gaugeStyle(.accessoryLinear)
                    Text((1 - viewData.percent).percent())
                        .font(.footnote)
                }
            }
        }
        .widgetURL(
            ApplicationRouter.deeplinkURL(
                scene: .home,
                view: .none,
                viewStates: []
            )
        )
    }
}

struct RemainingLockScreen: Widget {
    let kind: String = "RemainingLockScreen"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: RemainingLockScreenProvider()
        ) { entry in
            RemainingLockScreenView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName(String.localizable(by: .widgetTitleRemainingLockScreen))
        .description(String.localizable(by: .widgetDescriptionRemainingLockScreen))
        .supportedFamilies([.accessoryCircular, .accessoryRectangular])
    }
}

#Preview(as: .systemSmall) {
    RemainingLockScreen()
} timeline: {
    RemainingLockScreenEntry(
        viewData: WidgetExpensesViewDataMock()
    )
    RemainingLockScreenEntry(
        viewData: WidgetExpensesViewDataMock()
    )
    RemainingLockScreenEntry(
        viewData: WidgetExpensesViewDataMock()
    )
}
