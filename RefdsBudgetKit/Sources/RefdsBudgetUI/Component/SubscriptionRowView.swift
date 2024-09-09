import SwiftUI
import RefdsUI
import RefdsBudgetPresentation

public struct SubscriptionRowView: View {
    @Environment(\.isPro) private var isPro
    @Environment(\.navigate) private var navigate
    
    @ViewBuilder
    public var body: some View {
        if !isPro {
            RefdsButton {
                navigate?.to(
                    scene: .premium,
                    view: .none,
                    viewStates: []
                )
            } label: {
                HStack(spacing: 5) {
                    VStack(alignment: .leading) {
                        HStack(spacing: 3) {
                            RefdsText(.localizable(by: .subscriptionBecomePremium), style: .callout, weight: .bold)
                            RefdsText(.localizable(by: .subscriptionNavigationTitle), style: .callout, color: .accentColor, weight: .bold, lineLimit: 1)
                        }
                        RefdsText(.localizable(by: .subscriptionSubtitle).capitalizedSentence, style: .footnote, color: .secondary)
                    }
                    Spacer()
                    RefdsIconRow(
                        .boltFill,
                        color: .accentColor
                    )
                }
            }
        }
    }
}

#Preview {
    List {
        SubscriptionRowView()
            .environment(\.isPro, false)
    }
}
