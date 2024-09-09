import SwiftUI
import RefdsUI
import Charts
import RefdsBudgetResource

public struct ComparisonBarView: View {
    private var baseValue: Double
    private var compareValue: Double
    private var color: Color
    
    public init(
        baseValue: Double,
        compareValue: Double,
        color: Color
    ) {
        self.baseValue = baseValue
        self.compareValue = compareValue
        self.color = color
    }
    
    public var body: some View {
        Chart {
            buildMark(amount: baseValue)
            buildMark(amount: compareValue)
        }
        .background(Color.secondary.opacity(0.1))
        .chartLegend(.hidden)
        .clipShape(.rect(cornerRadius: 6))
        .chartXAxis(.hidden)
        .chartXScale(domain: 0 ... (baseValue + compareValue))
        .frame(height: 22)
        .padding(.vertical, .padding(.small))
    }
    
    private func buildMark(amount: Double) -> some ChartContent {
        BarMark(x: .value("x", amount))
            .foregroundStyle(amount == baseValue ? color.opacity(0.5) : color)
    }
}

#Preview {
    List {
        ComparisonBarView(
            baseValue: .random(in: 20 ... 100),
            compareValue: .random(in: 20 ... 100),
            color: .accentColor
        )
    }
}
