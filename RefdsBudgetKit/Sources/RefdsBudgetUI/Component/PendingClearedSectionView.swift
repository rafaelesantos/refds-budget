import SwiftUI
import Charts
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct PendingClearedSectionView: View {
    @Environment(\.privacyMode) private var privacyMode
    
    private let viewData: PendingClearedSectionViewDataProtocol
    
    public init(viewData: PendingClearedSectionViewDataProtocol) {
        self.viewData = viewData
    }
    
    private var headerTitle: String {
        .localizable(by: .addTransactionStatusPending) +
        " • " +
        .localizable(by: .addTransactionStatusCleared)
    }
    
    public var body: some View {
        RefdsSection {
            Group {
                rowProgressChartView
                rowInfoView
            }
            .budgetSubscription()
        } header: {
            RefdsText(
                headerTitle,
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var rowProgressChartView: some View {
        Chart {
            buildMark(
                amount: viewData.pendingAmount,
                style: .localizable(by: .addTransactionStatusPending)
            )
            buildMark(
                amount: viewData.clearedAmount,
                style: .localizable(by: .addTransactionStatusCleared)
            )
        }
        .background(Color.secondary.opacity(0.1))
        .chartLegend(.hidden)
        .clipShape(.rect(cornerRadius: 8))
        .chartXAxis(.hidden)
        .chartXScale(domain: 0 ... (viewData.pendingAmount + viewData.clearedAmount))
        .frame(height: 35)
        .padding(.vertical, .padding(.small))
    }
    
    private func buildMark(amount: Double, style: String) -> some ChartContent {
        let total = viewData.pendingAmount + viewData.clearedAmount
        let percent = amount / (total == .zero ? 1 : total)
        return BarMark(
            x: .value("x", amount)
        )
        .foregroundStyle(style == .localizable(by: .addTransactionStatusPending) ? .orange : .green)
        .annotation(position: .overlay, alignment: .center, spacing: 5) {
            HStack {
                RefdsText(
                    percent.percent(),
                    style: .footnote,
                    color: .white,
                    weight: .bold
                )
                .contentTransition(.numericText())
                .refdsRedacted(if: privacyMode)
                .refdsTag(color: .white)
                
                RefdsText(
                    (style == .localizable(by: .addTransactionStatusPending) ? viewData.pendingCount : viewData.clearedCount).asString,
                    style: .footnote,
                    color: .white,
                    weight: .bold
                )
                .refdsRedacted(if: privacyMode)
                .refdsTag(color: .white)
            }
        }
    }
    
    private var rowInfoView: some View {
        HStack {
            Spacer(minLength: .zero)
            
            VStack(alignment: .leading, spacing: .zero) {
                HStack(spacing: .padding(.small)) {
                    BubbleColorView(
                        color: .orange,
                        isSelected: true,
                        size: 14
                    )
                    
                    RefdsText(
                        .localizable(by: .addTransactionStatusPending),
                        style: .callout,
                        color: .secondary
                    )
                }
                
                RefdsText(viewData.pendingAmount.currency(), style: .title3, weight: .bold)
                    .contentTransition(.numericText())
                    .refdsRedacted(if: privacyMode)
            }
            
            Spacer(minLength: .zero)
            RefdsIcon(.xmark, color: .secondary)
            Spacer(minLength: .zero)
            
            VStack(alignment: .trailing, spacing: .zero) {
                HStack(spacing: .padding(.small)) {
                    RefdsText(
                        .localizable(by: .addTransactionStatusCleared),
                        style: .callout,
                        color: .secondary
                    )
                    
                    BubbleColorView(
                        color: .green,
                        isSelected: true,
                        size: 14
                    )
                }
                
                RefdsText(viewData.clearedAmount.currency(), style: .title3, weight: .bold)
                    .contentTransition(.numericText())
                    .refdsRedacted(if: privacyMode)
            }
    
            Spacer(minLength: .zero)
        }
    }
}

#Preview {
    List {
        PendingClearedSectionView(viewData: PendingClearedSectionViewDataMock())
    }
}
