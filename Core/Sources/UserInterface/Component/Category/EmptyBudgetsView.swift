import SwiftUI
import RefdsUI
import RefdsShared
import Presentation

struct EmptyBudgetsView: View {
    @Environment(\.navigate) private var navigate
    var viewStates: [RouteViewState] = []
    
    @ViewBuilder
    var body: some View {
        RefdsText(
            .localizable(by: .categoriesEmptyBudgetsDescription),
            style: .callout,
            color: .secondary
        )
        RefdsButton {
            navigate?.to(
                scene: .current,
                view: .addBudget,
                viewStates: viewStates
            )
        } label: {
            HStack(spacing: .padding(.medium)) {
                RefdsIconRow(.dollarsign)
                RefdsText(
                    .localizable(by: .categoriesEmptyBudgetsButton),
                    style: .callout
                )
                Spacer()
                RefdsIcon(
                    .chevronRight,
                    color: .secondary.opacity(0.5),
                    style: .callout
                )
            }
        }
    }
}

#Preview {
    EmptyBudgetsView()
}
