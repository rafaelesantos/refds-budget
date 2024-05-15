import SwiftUI
import RefdsUI
import Charts

public struct DateChartView: View {
    @Environment(\.privacyMode) private var privacyMode
    @State private var chartSelection: String = ""
    private let data: [(x: Date, y: Double, percentage: Double?)]
    private let format: String.DateFormat
    
    init(data: [(x: Date, y: Double, percentage: Double?)], format: String.DateFormat = .custom("MMMM, yyyy")) {
        self.data = data.reversed()
        self.format = format
    }
    
    public var body: some View {
        RefdsSection {
            Group {
                seletedBarView
                chartView
                    .padding(.top, -15)
            }
            .budgetSubscription()
        } header: {
            RefdsText(
                .localizable(by: .categoriesChartHeader),
                style: .footnote,
                color: .secondary
            )
        }
        .onAppear {
            withAnimation {
                if let date = data.first?.x.asString(withDateFormat: format) {
                    chartSelection = date
                }
            }
        }
    }
    
    @ViewBuilder
    private var seletedBarView: some View {
        if let value = data.first(where: { chartSelection == $0.x.asString(withDateFormat: format) })?.y,
           let position = data.sorted(by: { $0.y > $1.y }).firstIndex(where: { chartSelection == $0.x.asString(withDateFormat: format) })?.asString.asInt {
            HStack(spacing: .padding(.small)) {
                if position < 9 {
                    rankSealView(for: position)
                }
                RefdsText(chartSelection, style: .callout)
                Spacer()
                RefdsText(value.currency(), style: .callout, weight: .bold)
                    .contentTransition(.numericText())
                    .refdsRedacted(if: privacyMode)
            }
        }
    }
    
    private func rankSealView(for index: Int) -> some View {
        ZStack {
            RefdsIcon(
                .sealFill,
                color: .yellow.opacity(0.2),
                size: 25
            )
            
            RefdsText(
                (index + 1).asString,
                style: .caption2,
                color: .yellow,
                weight: .heavy
            )
        }
        .padding(.vertical, 3)
    }
    
    private var chartView: some View {
        Chart {
            ForEach(data.indices, id: \.self) { index in
                let data = data[index]
                buildMark(x: data.x, y: data.y, percentage: data.percentage)
            }
        }
        .chartYAxis { AxisMarks(position: .trailing) }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .frame(height: 200)
        .padding(.vertical)
        .padding(.top)
        .chartOverlay { proxy in
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(.clear)
                        .contentShape(.rect)
                        .onTapGesture { location in
                            guard let plotFrame = proxy.plotFrame else { return }
                            let position = location.x - geometry[plotFrame].origin.x
                            guard let date: String = proxy.value(atX: position) else { return }
                            withAnimation { chartSelection = date.asDate(withFormat: .dayMonthYear)?.asString(withDateFormat: format) ?? "" }
                        }
                }
            }
        }
    }
    
    private func buildMark(x: Date, y: Double, percentage: Double?) -> some ChartContent {
        BarMark(
            x: .value("x", x.asString(withDateFormat: .dayMonthYear)),
            y: .value("y", y),
            width: 20
        )
        .foregroundStyle(percentage?.riskColor ?? .accentColor)
    }
}

#Preview {
    let data: [(x: Date, y: Double, percentage: Double?)] = (1 ... 10).map { _ in
        (x: .random, y: .random(in: 1 ... 10), percentage: nil)
    }.sorted(by: { $0.x < $1.x })
    return DateChartView(data: data).padding(.horizontal)
}
