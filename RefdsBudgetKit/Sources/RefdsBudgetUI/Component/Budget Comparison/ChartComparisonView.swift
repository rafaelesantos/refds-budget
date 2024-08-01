import SwiftUI
import RefdsUI
import Charts
import RefdsBudgetPresentation

public struct ChartComparisonView: View {
    @Environment(\.privacyMode) private var privacyMode
    
    @State private var data: [BudgetComparisonChartViewDataProtocol] = []
    @State private var chartSelection: String = ""
    
    private let viewData: [BudgetComparisonChartViewDataProtocol]
    @Binding private var selection: BudgetComparisonChartViewDataProtocol?
    
    public init(
        viewData: [BudgetComparisonChartViewDataProtocol],
        selection: Binding<BudgetComparisonChartViewDataProtocol?>
    ) {
        self.viewData = viewData
        self._selection = selection
    }
    
    public var body: some View {
        chartView
            .onAppear { reload() }
            .onChange(of: viewData.count) { reload() }
            .onChange(of: chartSelection) { handlerChartSelection() }
    }
    
    private func handlerChartSelection() {
        if let selection = data.first(where: { $0.domain.lowercased() == chartSelection.lowercased() }) {
            withAnimation {
                self.selection = selection
            }
        }
    }
    
    private func reload() {
        withAnimation {
            chartSelection = viewData.first?.domain ?? ""
        }
        
        guard data.isEmpty else { return }
        data = viewData
        viewData.indices.forEach { index in
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    data[index].isAnimated = true
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
        .chartLegend(.hidden)
        .frame(height: 150)
        .padding(.vertical)
        .padding(.top)
        .chartForegroundStyleScale([
            "base": Color.accentColor.opacity(0.5),
            "compare": Color.accentColor
        ])
        .chartOverlay { proxy in
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(.clear)
                        .contentShape(.rect)
                        .onTapGesture { location in
                            guard let plotFrame = proxy.plotFrame else { return }
                            let position = location.x - geometry[plotFrame].origin.x
                            guard let category: String = proxy.value(atX: position) else { return }
                            withAnimation { chartSelection = category }
                        }
                }
            }
        }
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
}
