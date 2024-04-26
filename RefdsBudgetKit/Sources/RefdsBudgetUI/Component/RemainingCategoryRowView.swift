import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct RemainingCategoryRowView: View {
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
            
            HStack(spacing: .zero) {
                VStack(spacing: .padding(.extraSmall)) {
                    HStack(spacing: .padding(.small)) {
                        HStack {
                            statusIconView
                            RefdsText(viewData.name.capitalized, weight: .bold, lineLimit: 1)
                        }
                        Spacer(minLength: .zero)
                        RefdsText(budget.currency(), style: .callout, lineLimit: 1)
                            .contentTransition(.numericText())
                    }
                    
                    HStack(spacing: .padding(.small)) {
                        RefdsText(.localizable(by: .homeRemainingCategoryTransactions, with: viewData.transactionsAmount), style: .callout, color: .secondary)
                        Spacer(minLength: .zero)
                        RefdsText((1 - viewData.percentage).percent(), style: .callout, color: .secondary)
                    }
                }
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
