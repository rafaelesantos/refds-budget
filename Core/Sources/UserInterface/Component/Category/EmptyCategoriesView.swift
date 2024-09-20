import SwiftUI
import RefdsUI
import RefdsShared

struct EmptyCategoriesView: View {
    @Environment(\.navigate) private var navigate
    
    @ViewBuilder
    var body: some View {
        RefdsText(
            .localizable(by: .categoriesEmptyCategoriesDescription),
            style: .callout,
            color: .secondary
        )
        RefdsButton {
            navigate?.to(
                scene: .current,
                view: .addCategory,
                viewStates: []
            )
        } label: {
            HStack(spacing: .padding(.medium)) {
                RefdsIconRow(.squareStack3dForwardDottedlineFill)
                RefdsText(
                    .localizable(by: .categoriesEmptyCategoriesButton),
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
    EmptyCategoriesView()
}
