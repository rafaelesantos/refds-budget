import SwiftUI
import RefdsUI
import RefdsShared
import Mock
import Domain
import Presentation

public struct BudgetItemView: View {
    @Environment(\.privacyMode) private var privacyMode
    private let viewData: BudgetItemViewDataProtocol
    
    @State private var percentage: Double = 0
    @State private var amount: Double = 0
    @State private var spend: Double = 0
    
    public init(viewData: BudgetItemViewDataProtocol) {
        self.viewData = viewData
    }
    
    private var rowTitle: String {
        viewData.date.asString(withDateFormat: .month) + ", " +
        viewData.date.asString(withDateFormat: .year)
    }
    
    public var body: some View {
        HStack(spacing: .zero) {
            VStack {
                RefdsScaleProgressView(
                    riskColor: viewData.percentage.riskColor,
                    size: 15
                )
            }
            .padding(.trailing, .padding(.medium))
            
            VStack(alignment: .leading) {
                HStack {
                    RefdsText(
                        rowTitle.capitalized,
                        style: .callout,
                        weight: .semibold
                    )
                    Spacer()
                    RefdsText(
                        amount.currency(),
                        style: .callout
                    )
                    .contentTransition(.numericText())
                    .refdsRedacted(if: privacyMode)
                }
                
                HStack {
                    RefdsText(
                        viewData.percentage.percent(),
                        style: .footnote,
                        color: .secondary
                    )
                    .refdsRedacted(if: privacyMode)
                    Spacer()
                    RefdsText(
                        spend.currency(),
                        style: .callout,
                        color: .secondary
                    )
                    .contentTransition(.numericText())
                    .refdsRedacted(if: privacyMode)
                }
            }
            
            Spacer()
            
            RefdsIcon(.chevronRight, color: .secondary.opacity(0.5), style: .callout)
        }
        .onAppear { updateStateValue() }
        .onChange(of: viewData.percentage) { updateStateValue() }
        .onChange(of: viewData.amount) { updateStateValue() }
        .onChange(of: viewData.spend) { updateStateValue() }
    }
    
    private func updateStateValue() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            withAnimation {
                percentage = viewData.percentage > 1 ? 1 : viewData.percentage
                amount = viewData.amount
                spend = viewData.spend
            }
        }
    }
}

#Preview {
    List {
        ForEach((1 ... 6), id: \.self) { _ in
            BudgetItemView(viewData: BudgetItemViewDataMock())
        }
    }
}
