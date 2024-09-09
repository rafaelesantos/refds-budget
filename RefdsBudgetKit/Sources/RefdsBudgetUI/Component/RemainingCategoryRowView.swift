import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct RemainingCategoryRowView: View {
    @Environment(\.privacyMode) private var privacyMode
    private let viewData: CategoryRowViewDataProtocol
    private let action: ((CategoryRowViewDataProtocol) -> Void)?
    
    @State private var budget: Double = .zero
    @State private var percentage: Double = .zero
    
    public init(
        viewData: CategoryRowViewDataProtocol,
        action: ((CategoryRowViewDataProtocol) -> Void)? = nil
    ) {
        self.viewData = viewData
        self.action = action
    }
    
    public var body: some View {
        content
            .onAppear { updateStateValue() }
            .onChange(of: viewData.budget) { updateStateValue() }
            .onChange(of: viewData.percentage) { updateStateValue() }
    }
    
    private var content: some View {
        HStack(spacing: .padding(.medium)) {
            if let icon = RefdsIconSymbol(rawValue: viewData.icon) {
                    RefdsIconRow(icon, color: viewData.color)
            }
            
            RefdsScaleProgressView(riskColor: viewData.percentage.riskColor)
                .padding(.vertical, 2)
            
            VStack(spacing: .zero) {
                HStack {
                    RefdsText(viewData.name.capitalized, style: .callout, lineLimit: 1)
                    Spacer(minLength: .zero)
                    RefdsText(budget.currency(), style: .callout, weight: .semibold, lineLimit: 1)
                        .contentTransition(.numericText())
                        .refdsRedacted(if: privacyMode)
                }
                
                HStack {
                    RefdsText(
                        .localizable(by: .homeRemainingCategoryTransactions, with: viewData.transactionsAmount),
                        style: .callout,
                        color: .secondary
                    )
                    .refdsRedacted(if: privacyMode)
                    
                    Spacer(minLength: .zero)
                    RefdsText(
                        (1 - viewData.percentage).percent(),
                        style: .callout,
                        color: .secondary
                    )
                    .refdsRedacted(if: privacyMode)
                }
            }
            
            RefdsIcon(.chevronRight, color: .secondary.opacity(0.5), style: .callout)
        }
    }
    
    private func updateStateValue() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            withAnimation {
                budget = viewData.budget - viewData.spend
                percentage = viewData.percentage > 1 ? 1 : viewData.percentage
            }
        }
    }
}

#Preview {
    List {
        ForEach((1 ... 5).indices, id: \.self) { _ in
            RemainingCategoryRowView(viewData: CategoryRowViewDataMock())
        }
    }
}
