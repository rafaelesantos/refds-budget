import SwiftUI
import RefdsUI
import Charts

public struct DateChartView: View {
    @Environment(\.privacyMode) private var privacyMode
    @State private var chartSelection: String = ""
    @State private var data: [(x: Date, y: Double, percentage: Double?, isAnimate: Bool)] = []
    
    private let dateData: [(x: Date, y: Double, percentage: Double?, isAnimate: Bool)]
    private let format: String.DateFormat
    
    init(
        data: [(x: Date, y: Double, percentage: Double?, isAnimate: Bool)],
        format: String.DateFormat = .custom("MMMM, yyyy")
    ) {
        self.dateData = data.reversed()
        self.format = format
    }
    
    public var body: some View {
        Group {
            seletedBarView
            chartView
                .padding(.top, -15)
        }
        .budgetSubscription()
        .onChange(of: dateData.first?.y ?? .zero) { updateData() }
        .onChange(of: dateData.count) { updateData() }
        .onAppear { reloadData() }
    }
    
    private func reloadData() {
        withAnimation {
            if let date = dateData.first?.x.asString(withDateFormat: format) {
                chartSelection = date
            }
        }
        guard data.isEmpty else { return }
        data = dateData
        dateData.indices.forEach { index in
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    data[index].isAnimate = true
                }
            }
        }
    }
    
    private func updateData() {
        data = []
        reloadData()
    }
    
    @ViewBuilder
    private var seletedBarView: some View {
        if let value = data.first(where: { chartSelection == $0.x.asString(withDateFormat: format) })?.y,
           let position = data.sorted(by: { $0.y > $1.y }).firstIndex(where: { chartSelection == $0.x.asString(withDateFormat: format) })?.asString.asInt {
            HStack(spacing: .padding(.small)) {
                if position < 9 {
                    rankSealView(for: position)
                }
                RefdsText(chartSelection.capitalized, style: .callout)
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
                buildMark(
                    x: data.x,
                    y: data.y,
                    percentage: data.percentage,
                    isAnimate: data.isAnimate
                )
            }
        }
        .chartYAxis { AxisMarks(position: .trailing) }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .chartYVisibleDomain(length: dateData.max(by: { $0.y < $1.y })?.y ?? .zero)
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
                            withAnimation {
                                chartSelection = date.asDate(withFormat: .dayMonthYear)?.asString(withDateFormat: format) ?? ""
                            }
                        }
                }
            }
        }
    }
    
    private func buildMark(
        x: Date,
        y: Double,
        percentage: Double?,
        isAnimate: Bool
    ) -> some ChartContent {
        BarMark(
            x: .value("x", x.asString(withDateFormat: .dayMonthYear)),
            y: .value("y", isAnimate ? y : .zero),
            width: 20
        )
        .foregroundStyle(percentage?.riskColor ?? .accentColor)
    }
}

#Preview {
    let data: [(x: Date, y: Double, percentage: Double?, isAnimate: Bool)] = (1 ... 10).map { _ in
        (x: .random, y: .random(in: 1 ... 10), percentage: nil, isAnimate: false)
    }.sorted(by: { $0.x < $1.x })
    return DateChartView(data: data).padding(.horizontal)
}
