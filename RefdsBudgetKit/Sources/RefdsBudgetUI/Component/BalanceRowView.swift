import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct BalanceRowView: View {
    @Environment(\.privacyMode) private var privacyMode
    private let viewData: BalanceRowViewDataProtocol
    private let isRemaining: Bool
    
    @State private var expense: Double = 0
    @State private var percentage: Double = 0
    
    public init(viewData: BalanceRowViewDataProtocol, isRemaining: Bool = false) {
        self.viewData = viewData
        self.isRemaining = isRemaining
    }
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: .padding(.extraSmall)) {
                if let title = viewData.title {
                    HStack(spacing: .padding(.small)) {
                        if !isRemaining {
                            RefdsText(
                                viewData.amount.asString,
                                style: .footnote,
                                color: .accentColor,
                                weight: .bold
                            )
                            .refdsRedacted(if: privacyMode)
                            .padding(3)
                            .padding(.horizontal, 3)
                            .background(Color.accentColor.opacity(0.1))
                            .clipShape(.rect(cornerRadius: 3))
                        }
                        
                        RefdsText(
                            title.uppercased(),
                            style: .caption,
                            color: .accentColor,
                            weight: .bold
                        )
                        
                        if isRemaining {
                            Spacer(minLength: .zero)
                            
                            RefdsText(
                                (1 - percentage).percent(),
                                style: .footnote,
                                color: percentage.riskColor,
                                weight: .bold
                            )
                            .refdsRedacted(if: privacyMode)
                            .contentTransition(.numericText())
                            .refdsTag(
                                color: percentage.riskColor,
                                cornerRadius: 5
                            )
                        }
                    }
                }
                
                RefdsText(
                    expense.currency(),
                    style: .largeTitle,
                    color: .primary,
                    weight: .bold,
                    alignment: .center
                )
                .contentTransition(.numericText())
                .refdsRedacted(if: privacyMode)
                
                if !isRemaining {
                    HStack {
                        if let subtitle = viewData.subtitle {
                            RefdsText(
                                subtitle.uppercased(),
                                style: .footnote,
                                color: .secondary,
                                weight: .bold
                            )
                        }
                        
                        RefdsText(
                            viewData.budget.currency(),
                            style: .footnote,
                            color: .secondary,
                            weight: .bold
                        )
                        .padding(3)
                        .padding(.horizontal, 3)
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 3))
                        .refdsRedacted(if: privacyMode)
                    }
                }
            }
            
            Spacer(minLength: .zero)
            
            if !isRemaining {
                RefdsCircularProgressView(
                    percentage,
                    size: 90,
                    color: percentage.riskColor,
                    scale: 0.08
                )
                .refdsRedacted(if: privacyMode)
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
                let percentage = viewData.spendPercentage
                self.percentage = isRemaining ? (1 - percentage) : percentage
            }
        }
    }
}

#Preview {
    BalanceRowView(viewData: BalanceRowViewDataMock())
        .refdsCard()
        .padding(.padding(.extraLarge))
}
