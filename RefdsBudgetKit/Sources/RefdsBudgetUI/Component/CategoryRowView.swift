import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct CategoryRowView: View {
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
        rowCategory
            .onAppear { updateStateValue() }
            .onChange(of: viewData.budget) { updateStateValue() }
            .onChange(of: viewData.percentage) { updateStateValue() }
    }
    
    private var rowCategory: some View {
        HStack(spacing: .padding(.medium)) {
            if let icon = RefdsIconSymbol(rawValue: viewData.icon) {
                VStack {
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
            }
            
            HStack(spacing: .zero) {
                VStack(alignment: .leading, spacing: .padding(.extraSmall)) {
                    HStack(spacing: .padding(.small)) {
                        RefdsText(viewData.name.capitalized, weight: .bold, lineLimit: 1)
                        Spacer(minLength: .zero)
                        RefdsText(budget.currency(), style: .callout, lineLimit: 1)
                            .contentTransition(.numericText())
                            .refdsRedacted(if: privacyMode)
                    }
                    
                    if let description = viewData.description, !description.isEmpty {
                        RefdsText(description, style: .callout, color: .secondary, lineLimit: 2)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer(minLength: .padding(.extraSmall))
                
                RefdsIcon(.chevronRight, color: .secondary.opacity(0.5), style: .callout)
            }
        }
    }
    
    private var rowTransactions: some View {
        HStack(spacing: .padding(.medium)) {
            RefdsText(
                viewData.transactionsAmount.asString,
                style: .caption,
                color: .primary,
                weight: .bold
            )
            .refdsRedacted(if: privacyMode)
            .padding(.padding(.extraSmall))
            .frame(width: 40)
            .background(.secondary.opacity(0.05))
            .clipShape(.rect(cornerRadius: 5))
            RefdsText(.localizable(by: .categoryRowTransactions), style: .callout)
        
            Spacer(minLength: .zero)
            RefdsText(viewData.spend.currency(), style: .callout, color: .secondary)
                .refdsRedacted(if: privacyMode)
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
            CategoryRowView(viewData: CategoryRowViewDataMock())
        }
    }
}
