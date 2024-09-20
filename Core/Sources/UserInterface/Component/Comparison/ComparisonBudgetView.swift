import SwiftUI
import RefdsUI

struct ComparisonBudgetView: View {
    private let action: (Bool) -> Void
    
    init(action: @escaping (Bool) -> Void) {
        self.action = action
    }
    
    var body: some View {
        RefdsSection {
            aiRowView
            VStack(alignment: .center, spacing: .large) {
                headerView
                contentView
                compareButton
            }
            .padding(.vertical, .small)
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
        HStack(spacing: .small) {
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
    List {
        ComparisonBudgetView { _ in }
    }
}
