import SwiftUI
import RefdsUI
import Charts
import Domain
import Mock

struct ComparisonChartView: View {
    @Environment(\.privacyMode) private var privacyMode
    
    @State private var data: [BudgetComparisonChartViewDataProtocol] = []
    @State private var valueSelection: String = ""
    
    private let viewData: [BudgetComparisonChartViewDataProtocol]
    @Binding private var selection: BudgetComparisonChartViewDataProtocol?
    private let hasDomain: Bool
    
    init(
        viewData: [BudgetComparisonChartViewDataProtocol],
        selection: Binding<BudgetComparisonChartViewDataProtocol?>,
        hasDomain: Bool = true
    ) {
        self.viewData = viewData
        self._selection = selection
        self.hasDomain = hasDomain
    }
    
    var body: some View {
        chartView
            .onAppear { reload() }
            .onChange(of: viewData.count) { reload() }
            .onChange(of: valueSelection) { handlerChartSelection() }
    }
    
    private func handlerChartSelection() {
        if let selection = data.first(where: { $0.domain.lowercased() == valueSelection.lowercased() }) {
            withAnimation {
                self.selection = selection
            }
        }
    }
    
    private func reload() {
        withAnimation {
            valueSelection = viewData.first?.domain ?? ""
        }
        
        guard data.isEmpty else { return }
        data = viewData
        viewData.indices.forEach { index in
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    if data.indices.contains(index) {
                        data[index].isAnimated = true
                    }
                }
            }
        }
    }
    
    private var chartView: some View {
        Chart {
            ForEach(data.indices, id: \.self) { index in
                let data = data[index]
                buildMark(x: data.domain, y: data.base, id: "base", isAnimated: data.isAnimated)
                buildMark(x: data.domain, y: data.compare, id: "compare", isAnimated: data.isAnimated)
            }
        }
        .chartYAxis { AxisMarks(position: .trailing) }
        .chartYScale(range: .plotDimension(padding: 10))
        .chartLegend(.hidden)
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 5.5)
        .frame(height: 160)
        .padding(.vertical)
        .padding(.top)
        .chartForegroundStyleScale(foregroundColors)
        .chartOverlay { chartOverlayView(for: $0) }
    }
    
    private var foregroundColors: KeyValuePairs<String, Color> {
        [
            "base": (selection?.color ?? .accentColor).opacity(0.5),
            "compare": selection?.color ?? .accentColor
        ]
    }
    
    private func buildMark(
        x: String,
        y: Double,
        id: String,
        isAnimated: Bool
    ) -> some ChartContent {
        LineMark(
            x: .value("x", x),
            y: .value("y", isAnimated ? y : .zero)
        )
        .interpolationMethod(.cardinal)
        .foregroundStyle(by: .value("x-style", id))
        .symbol(.circle)
    }
    
    private func chartOverlayView(for proxy: ChartProxy) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(.clear)
                    .contentShape(.rect)
                    .onTapGesture {
                        handlerGesture(
                            for: proxy,
                            and: geometry,
                            on: $0
                        )
                    }
            }
        }
    }
    
    private func handlerGesture(
        for proxy: ChartProxy,
        and geometry: GeometryProxy,
        on location: CGPoint
    ) {
        guard let plotFrame = proxy.plotFrame else { return }
        let position = location.x - geometry[plotFrame].origin.x
        guard let value: String = proxy.value(atX: position) else { return }
        withAnimation { valueSelection = value }
    }
}

#Preview {
    struct ContentView: View {
        @State private var selection: BudgetComparisonChartViewDataProtocol?
        var body: some View {
            List {
                ComparisonChartView(
                    viewData: (1 ... 10).map { _ in BudgetComparisonChartViewDataMock() },
                    selection: $selection,
                    hasDomain: true
                )
            }
        }
    }
    return ContentView()
}
