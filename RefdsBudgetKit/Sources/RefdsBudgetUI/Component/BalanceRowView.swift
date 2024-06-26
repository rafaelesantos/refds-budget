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
            VStack(alignment: .leading) {
                headerView
                    .frame(height: 10)
                    .padding(.bottom, -6)
                amountView
            }
            
            Spacer(minLength: 5)
            
            if !isRemaining {
                RefdsCircularProgressView(
                    percentage,
                    size: 85,
                    color: percentage.riskColor,
                    scale: 0.095
                )
                .minimumScaleFactor(0.7)
                .refdsRedacted(if: privacyMode)
            }
        }
        .padding()
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
    
    @ViewBuilder
    private var headerView: some View {
        if let title = viewData.title {
            HStack(spacing: 4) {
                RefdsText(
                    title.uppercased(),
                    style: .caption,
                    color: .accentColor,
                    weight: .bold
                )
                
                if !isRemaining {
                    RefdsText(
                        "•",
                        style: .footnote,
                        color: .accentColor,
                        weight: .bold
                    )
                    
                    RefdsText(
                        viewData.amount.asString,
                        style: .footnote,
                        color: .accentColor,
                        weight: .bold
                    )
                    .refdsRedacted(if: privacyMode)
                }
                
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
    }
    
    @ViewBuilder
    private var amountView: some View {
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
            HStack(spacing: 4) {
                if let subtitle = viewData.subtitle {
                    RefdsText(
                        subtitle.uppercased(),
                        style: .footnote,
                        color: .secondary,
                        weight: .bold
                    )
                }
                
                RefdsText(
                    "•",
                    style: .footnote,
                    color: .secondary,
                    weight: .bold
                )
                
                RefdsText(
                    viewData.budget.currency(),
                    style: .footnote,
                    color: .secondary,
                    weight: .bold
                )
                .refdsRedacted(if: privacyMode)
            }
            .frame(height: 10)
            .padding(.top, -12)
        }
    }
}

#Preview {
    List {
        BalanceRowView(viewData: BalanceRowViewDataMock())
    }
}
