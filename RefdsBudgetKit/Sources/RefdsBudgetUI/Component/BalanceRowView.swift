import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct BalanceRowView: View {
    private let viewData: BalanceRowViewDataProtocol
    
    @State private var expense: Double = 0
    @State private var percentage: Double = 0
    
    public init(viewData: BalanceRowViewDataProtocol) {
        self.viewData = viewData
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: .padding(.extraSmall)) {
            if let title = viewData.title {
                RefdsText(
                    title.uppercased(),
                    style: .caption,
                    color: .accentColor,
                    weight: .bold
                )
            }
            
            HStack(alignment: .bottom) {
                RefdsText(
                    expense.currency(),
                    style: .largeTitle,
                    color: .primary,
                    weight: .bold,
                    alignment: .center
                )
                .contentTransition(.numericText())
                
                Spacer(minLength: .zero)
                
                RefdsText(
                    viewData.spendPercentage.percent(),
                    style: .title3,
                    weight: .light,
                    alignment: .center
                )
                .padding(.bottom, 3)
            }
            
            ProgressView(value: percentage, total: 1)
                .tint(percentage.riskColor)
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
                .padding(.vertical, .padding(.extraSmall))
            
            HStack {
                if let subtitle = viewData.subtitle {
                    RefdsText(
                        subtitle.uppercased(),
                        style: .footnote,
                        color: .secondary,
                        weight: .bold
                    )
                    
                    Spacer(minLength: .zero)
                }
                
                RefdsText(
                    viewData.budget.currency(),
                    style: .callout,
                    color: .secondary,
                    weight: .bold
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, .padding(.extraSmall))
        .onAppear { updateStateValues() }
        .onChange(of: viewData.expense) { updateStateValues() }
        .onChange(of: viewData.spendPercentage) { updateStateValues() }
    }
    
    private func updateStateValues() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            withAnimation {
                expense = viewData.expense
                percentage = viewData.spendPercentage > 1 ? 1 : viewData.spendPercentage
            }
        }
    }
}

#Preview {
    BalanceRowView(viewData: BalanceRowViewDataMock())
        .refdsCard()
        .padding(.padding(.extraLarge))
}
