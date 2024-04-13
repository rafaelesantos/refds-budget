import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct CategoryRowView: View {
    private let viewData: CategoryRowViewDataProtocol
    
    @State private var budget: Double = .zero
    @State private var percentage: Double = .zero
    
    public init(viewData: CategoryRowViewDataProtocol) {
        self.viewData = viewData
    }
    
    public var body: some View {
        Section {
            rowCategory
            rowTransactions
            rowDescription
        }
        .onAppear { updateStateValue() }
        .onChange(of: viewData.budget) { updateStateValue() }
        .onChange(of: viewData.percentage) { updateStateValue() }
    }
    
    private var rowCategory: some View {
        HStack(spacing: .padding(.medium)) {
            if let icon = RefdsIconSymbol(rawValue: viewData.icon) {
                RefdsIcon(
                    icon,
                    color: viewData.color,
                    size: .padding(.medium)
                )
                .frame(width: .padding(.medium), height: .padding(.medium))
                .padding(10)
                .background(viewData.color.opacity(0.25))
                .clipShape(.rect(cornerRadius: .cornerRadius))
            }
            
            VStack(spacing: .padding(.extraSmall)) {
                HStack(spacing: .padding(.small)) {
                    RefdsText(viewData.name.capitalized, weight: .bold, lineLimit: 1)
                    Spacer(minLength: .zero)
                    RefdsText(budget.currency(), style: .callout, lineLimit: 1)
                        .contentTransition(.numericText())
                }
                
                HStack(spacing: .padding(.small)) {
                    ProgressView(value: percentage > 1 ? 1 : percentage, total: 1)
                        .tint(percentage.riskColor)
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                    RefdsText(viewData.percentage.percent(), style: .callout, color: .secondary)
                }
            }
        }
    }
    
    private var rowTransactions: some View {
        HStack(spacing: .padding(.medium)) {
            RefdsText(viewData.transactionsAmount.asString, style: .footnote, color: .secondary, weight: .bold)
                .padding(.padding(.extraSmall))
                .frame(width: 35)
                .background(.secondary.opacity(0.05))
                .clipShape(.rect(cornerRadius: 5))
            RefdsText(.localizable(by: .categoryRowTransactions), style: .callout)
        
            Spacer(minLength: .zero)
            RefdsText(viewData.spend.currency(), style: .callout, color: .secondary)
        }
    }
    
    @ViewBuilder
    private var rowDescription: some View {
        if let description = viewData.description, !description.isEmpty {
            RefdsText(description, style: .callout, color: .secondary)
        }
    }
    
    private func updateStateValue() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            withAnimation {
                budget = viewData.budget
                percentage = viewData.percentage
            }
        }
    }
}

#Preview {
    List {
        ForEach((1 ... 5).indices, id: \.self) { _ in
            CategoryRowView(viewData: CategoryRowViewDataMock())
        }
    }
}
