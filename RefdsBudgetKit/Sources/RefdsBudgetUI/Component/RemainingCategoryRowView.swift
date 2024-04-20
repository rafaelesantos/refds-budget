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
                        RefdsText(viewData.name.capitalized, weight: .bold, lineLimit: 1)
                        Spacer(minLength: .zero)
                        RefdsText(budget.currency(), style: .callout, lineLimit: 1)
                            .contentTransition(.numericText())
                    }
                    
                    HStack(spacing: .padding(.small)) {
                        ProgressView(value: percentage, total: 1)
                            .tint(percentage.riskColor)
                            .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        RefdsText((1 - viewData.percentage).percent(), style: .callout, color: .secondary)
                    }
                }
            }
        }
    }
    
    private func updateStateValue() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            withAnimation {
                budget = viewData.budget
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
