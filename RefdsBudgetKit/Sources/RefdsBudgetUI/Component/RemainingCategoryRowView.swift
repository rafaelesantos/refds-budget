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
                RefdsIcon(
                    icon,
                    color: viewData.color,
                    size: .padding(.medium)
                )
                .frame(width: .padding(.medium), height: .padding(.medium))
                .padding(10)
                .background(viewData.color.opacity(0.2))
                .clipShape(.rect(cornerRadius: .cornerRadius))
            }
            
            VStack(spacing: .zero) {
                HStack {
                    HStack {
                        statusIconView
                        RefdsText(viewData.name.capitalized, style: .callout, weight: .bold, lineLimit: 1)
                    }
                    Spacer(minLength: .zero)
                    RefdsText(budget.currency(), style: .callout, lineLimit: 1)
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
                
                ProgressView(
                    value: viewData.percentage > 1 ? 1 : viewData.percentage,
                    total: 1
                )
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
                .tint(viewData.percentage.riskColor)
                .padding(.top, 10)
                .padding(.bottom, 5)
            }
        }
    }
    
    private var statusIconView: some View {
        RefdsIcon(
            budget > 0 ? .arrowtriangleUpSquareFill : .arrowtriangleDownSquareFill,
            color: percentage.riskColor,
            size: 15,
            renderingMode: .hierarchical
        )
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
