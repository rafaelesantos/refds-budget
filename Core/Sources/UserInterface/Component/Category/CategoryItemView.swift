import SwiftUI
import RefdsUI
import RefdsShared
import Mock
import Domain
import Presentation

struct CategoryItemView: View {
    @Environment(\.privacyMode) private var privacyMode
    private let viewData: CategoryItemViewDataProtocol
    private let action: ((CategoryItemViewDataProtocol) -> Void)?
    
    @State private var budget: Double = .zero
    @State private var percentage: Double = .zero
    
    init(
        viewData: CategoryItemViewDataProtocol,
        action: ((CategoryItemViewDataProtocol) -> Void)? = nil
    ) {
        self.viewData = viewData
        self.action = action
    }
    
    var body: some View {
        rowCategory
            .onAppear { updateStateValue() }
            .onChange(of: viewData.budget) { updateStateValue() }
            .onChange(of: viewData.percentage) { updateStateValue() }
    }
    
    private var rowCategory: some View {
        HStack(spacing: .medium) {
            if let icon = RefdsIconSymbol(rawValue: viewData.icon) {
                VStack {
                    RefdsIcon(
                        icon,
                        color: viewData.color,
                        size: .medium
                    )
                    .frame(width: .medium, height: .medium)
                    .padding(10)
                    .background(viewData.color.opacity(0.2))
                    .clipShape(.rect(cornerRadius: .cornerRadius))
                }
            }
            
            HStack(spacing: .zero) {
                VStack(alignment: .leading) {
                    HStack(spacing: .small) {
                        RefdsText(
                            viewData.name.capitalized,
                            weight: .bold,
                            lineLimit: 1
                        )
                        
                        Spacer(minLength: .zero)
                        
                        RefdsText(
                            budget.currency(),
                            style: .callout,
                            lineLimit: 1
                        )
                        .contentTransition(.numericText())
                        .refdsRedacted(if: privacyMode)
                    }
                    
                    if let description = viewData.description, !description.isEmpty {
                        RefdsText(
                            description,
                            style: .callout,
                            color: .secondary,
                            lineLimit: 2
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer(minLength: .extraSmall)
                
                RefdsIcon(
                    .chevronRight,
                    color: .secondary.opacity(0.5),
                    style: .callout
                )
            }
        }
    }
    
    private var rowTransactions: some View {
        HStack(spacing: .medium) {
            RefdsText(
                viewData.transactionsAmount.asString,
                style: .caption,
                color: .primary,
                weight: .bold
            )
            .refdsRedacted(if: privacyMode)
            .padding(.extraSmall)
            .frame(width: 40)
            .background(.secondary.opacity(0.05))
            .clipShape(.rect(cornerRadius: 5))
            
            RefdsText(
                .localizable(by: .categoryRowTransactions),
                style: .callout
            )
        
            Spacer(minLength: .zero)
            
            RefdsText(
                viewData.spend.currency(),
                style: .callout,
                color: .secondary
            )
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
            CategoryItemView(viewData: CategoryItemViewDataMock())
        }
    }
}
