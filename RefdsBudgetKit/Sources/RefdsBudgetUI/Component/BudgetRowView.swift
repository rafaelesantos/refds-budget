import SwiftUI
import RefdsUI
import RefdsBudgetPresentation

public struct BudgetRowView: View {
    @Environment(\.privacyMode) private var privacyMode
    private let viewData: BudgetRowViewDataProtocol
    
    @State private var percentage: Double = 0
    @State private var amount: Double = 0
    
    public init(viewData: BudgetRowViewDataProtocol) {
        self.viewData = viewData
    }
    
    private var rowTitle: String {
        viewData.date.asString(withDateFormat: .month) + ", " +
        viewData.date.asString(withDateFormat: .year)
    }
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: .padding(.extraSmall)) {
                HStack {
                    RefdsText(rowTitle, style: .callout)
                    Spacer()
                    RefdsText(amount.currency(), style: .callout)
                        .contentTransition(.numericText())
                        .refdsRedacted(if: privacyMode)
                }
                
                if let description = viewData.description, !description.isEmpty {
                    RefdsText(description, style: .callout, color: .secondary)
                }
                
                HStack(spacing: .padding(.medium)) {
                    ProgressView(value: percentage, total: 1)
                        .tint(percentage.riskColor)
                    #if os(iOS)
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                    #endif
                        .padding(.vertical, .padding(.extraSmall))
                    RefdsText(
                        percentage.percent(),
                        style: .footnote,
                        color: .secondary
                    )
                    .refdsRedacted(if: privacyMode)
                }
            }
            
            Spacer()
            
            RefdsIcon(.chevronRight, color: .secondary.opacity(0.5), style: .callout)
        }
        .onAppear { updateStateValue() }
        .onChange(of: viewData.percentage) { updateStateValue() }
        .onChange(of: viewData.amount) { updateStateValue() }
    }
    
    private func updateStateValue() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            withAnimation {
                percentage = viewData.percentage > 1 ? 1 : viewData.percentage
                amount = viewData.amount
            }
        }
    }
}

#Preview {
    List {
        ForEach((1 ... 6), id: \.self) { _ in
            BudgetRowView(viewData: BudgetRowViewDataMock())
        }
    }
}
