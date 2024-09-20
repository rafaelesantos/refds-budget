import SwiftUI
import RefdsUI
import Charts

struct RiskLegendView: View {
    @State private var selectedLegend: (Color, Int, String)?
    private let color: (Color, Int, String)
    private let legends: [(Color, Int, String)] = [
        (.green, 25, "green"),
        (.yellow, 25, "yellow"),
        (.orange, 25, "orange"),
        (.red, 25, "red")
    ]
    
    init(color: Color = .green) {
        self.color = legends.first(where: { color == $0.0 }) ?? (.green, 25, "green")
    }
    
    private var bindingAngleSelection: Binding<Int?> {
        Binding {
            selectedLegend?.1
        } set: {
            if let value = $0,
               let legend = selectLegend(for: value) {
                withAnimation {
                    selectedLegend = legend
                }
            }
        }
    }
    
    private func selectLegend(for value: Int) -> (Color, Int, String)? {
        var total: Int = .zero
        
        for legend in legends {
            total += legend.1
            if value <= total { return legend }
        }
        
        return legends.last
    }
    
    var body: some View {
        HStack(spacing: .small) {
            infoView
            Spacer(minLength: .zero)
            chartView
        }
        .onAppear {
            withAnimation {
                selectedLegend = color
            }
        }
    }
    
    @ViewBuilder
    private var infoView: some View {
        if let selectedLegend = selectedLegend?.0 {
            VStack(alignment: .leading) {
                let title: String = selectedLegend == .green ? .localizable(by: .categoriesGreenLegendTitle):
                selectedLegend == .yellow ? .localizable(by: .categoriesYellowLegendTitle) :
                selectedLegend == .orange ? .localizable(by: .categoriesOrangeLegendTitle) :
                    .localizable(by: .categoriesRedLegendTitle)
                
                let description: String = selectedLegend == .green ? .localizable(by: .categoriesGreenLegendDescription):
                selectedLegend == .yellow ? .localizable(by: .categoriesYellowLegendDescription) :
                selectedLegend == .orange ? .localizable(by: .categoriesOrangeLegendDescription) :
                    .localizable(by: .categoriesRedLegendDescription)
                RefdsText(
                    title.uppercased(),
                    style: .footnote,
                    color: selectedLegend,
                    weight: .bold
                )
                .refdsTag(color: selectedLegend)
                RefdsText(description, style: .callout, color: .secondary)
            }
        }
    }
    
    private var chartView: some View {
        Chart(legends, id: \.0) {
            SectorMark(
                angle: .value("y", $0.1),
                innerRadius: .ratio(selectedLegend?.2 == $0.2 ? 0.5 : 0.6),
                outerRadius: .ratio(selectedLegend?.2 == $0.2 ? 1 : 0.9),
                angularInset: 4
            )
            .cornerRadius(1)
            .foregroundStyle(by: .value("x", $0.2))
            .opacity(selectedLegend?.2 == $0.2 ? 1 : 0.8)
        }
        .chartForegroundStyleScale(
            domain: legends.map  { $0.2 },
            range: legends.map { $0.0 }
        )
        .chartLegend(.hidden)
        .chartAngleSelection(value: bindingAngleSelection)
        .frame(width: 70, height: 70)
    }
}

#Preview {
    RiskLegendView()
}
