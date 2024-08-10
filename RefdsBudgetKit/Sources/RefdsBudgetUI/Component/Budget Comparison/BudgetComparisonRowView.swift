import SwiftUI
import RefdsUI

public struct BudgetComparisonRowView: View {
    private let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        RefdsSection {
            VStack(alignment: .center, spacing: .padding(.large)) {
                RefdsText(
                    .localizable(by: .comparisonRowDescription),
                    style: .callout,
                    alignment: .center
                )
                
                HStack(spacing: .padding(.small)) {
                    Spacer()
                    IconsIllustrationView()
                    RefdsIcon(.xmark, color: .secondary)
                    IconsIllustrationView()
                    Spacer()
                }
                
                RefdsButton(.localizable(by: .comparisonRowButton)) {
                    action()
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, .padding(.small))
            .budgetSubscription()
        } header: {
            RefdsText(
                .localizable(by: .comparisonRowHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
}

#Preview {
    BudgetComparisonRowView {}
}
