import SwiftUI
import RefdsUI

public struct ComparisonBudgetView: View {
    private let action: (Bool) -> Void
    
    public init(action: @escaping (Bool) -> Void) {
        self.action = action
    }
    
    public var body: some View {
        RefdsSection {
            aiRowView
            VStack(alignment: .center, spacing: .padding(.large)) {
                headerView
                contentView
                compareButton
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
    
    private var headerView: some View {
        RefdsText(
            .localizable(by: .comparisonRowDescription),
            style: .callout,
            alignment: .center
        )
    }
    
    private var aiRowView: some View {
        RefdsButton {
            action(true)
        } label: {
            HStack(spacing: 15) {
                RefdsIconRow(.cpuFill, color: .accentColor)
                RefdsText(.localizable(by: .aiTitle))
                Spacer()
                RefdsIcon(.chevronRight, color: .secondary.opacity(0.5), style: .callout)
            }
        }
    }
    
    private var contentView: some View {
        HStack(spacing: .padding(.small)) {
            Spacer()
            IconsIllustrationView()
            RefdsIcon(.xmark, color: .secondary)
            IconsIllustrationView()
            Spacer()
        }
    }
    
    private var compareButton: some View {
        RefdsButton(.localizable(by: .comparisonRowButton)) {
            action(false)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ComparisonBudgetView { _ in }
}
