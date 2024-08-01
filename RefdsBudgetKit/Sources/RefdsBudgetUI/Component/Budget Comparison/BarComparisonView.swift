import SwiftUI
import RefdsUI
import Charts
import RefdsBudgetResource

public struct BarComparisonView: View {
    private var baseValue: Double
    private var compareValue: Double
    
    public init(
        baseValue: Double,
        compareValue: Double
    ) {
        self.baseValue = baseValue
        self.compareValue = compareValue
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
            .foregroundStyle(amount == baseValue ? Color.accentColor.opacity(0.5) : Color.accentColor)
    }
}

#Preview {
    List {
        BarComparisonView(
            baseValue: .random(in: 20 ... 100),
            compareValue: .random(in: 20 ... 100)
        )
    }
}
