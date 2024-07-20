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
    @State private var isPresentedRiskLegend = false
    
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
            
            Spacer(minLength: 15)
            
            if !isRemaining {
                RefdsButton {
                    withAnimation {
                        isPresentedRiskLegend.toggle()
                    }
                } label: {
                    Gauge(
                        value: percentage > 1 ? 1 : percentage,
                        in: 0 ... 1
                    ) { EmptyView() } currentValueLabel: {
                        RefdsText(
                            percentage.percent(),
                            weight: .bold,
                            lineLimit: 1
                        )
                        .minimumScaleFactor(0.5)
                        .scaleEffect(0.7)
                        
                    }
                    .gaugeStyle(.accessoryCircular)
                    .scaleEffect(1.4)
                    .frame(width: 85, height: 85)
                    .tint(percentage.riskColor)
                    .refdsRedacted(if: privacyMode)
                }
                .popover(isPresented: $isPresentedRiskLegend) {
                    RiskLegendView(color: percentage.riskColor)
                        .padding()
                        .presentationCompactAdaptation(.popover)
                }
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
                } else {
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
                    .padding(.trailing, -15)
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
            alignment: .center,
            lineLimit: 1
        )
        .contentTransition(.numericText())
        .minimumScaleFactor(0.6)
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
