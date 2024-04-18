import SwiftUI
import Charts

public struct DateChartView<X: Plottable, Y: Plottable>: View {
    private let data: [(x: X, y: Y, percentage: Double?)]
    private let isScrollable: Bool
    
    init(data: [(x: X, y: Y, percentage: Double?)], isScrollable: Bool = true) {
        self.data = data
        self.isScrollable = isScrollable
    }
    
    public var body: some View {
        Chart {
            ForEach(data.indices, id: \.self) { index in
                let data = data[index]
                buildMark(x: data.x, y: data.y, percentage: data.percentage)
            }
        }
        .chartLegend(position: .overlay, alignment: .top, spacing: -20)
        .chartYAxis { AxisMarks(position: .trailing) }
        .if(isScrollable) {
            $0.chartScrollableAxes(.horizontal)
        }
        .frame(height: 200)
        .padding(.vertical)
        .padding(.top)
    }
    
    func buildMark(x: X, y: Y, percentage: Double?) -> some ChartContent {
        BarMark(
            x: .value("Data", x),
            y: .value("Value", y),
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
