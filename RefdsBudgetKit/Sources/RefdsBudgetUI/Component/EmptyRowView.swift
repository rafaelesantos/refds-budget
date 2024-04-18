import SwiftUI
import RefdsUI
import RefdsBudgetResource

public struct EmptyRowView: View {
    public let title: LocalizableKey
    public let description: LocalizableKey
    
    public init(
        title: LocalizableKey,
        description: LocalizableKey = .emptyDescriptions
    ) {
        self.title = title
        self.description = description
    }
    
    public var body: some View {
        HStack(spacing: .zero) {
            VStack(alignment: .leading, spacing: .padding(.extraSmall)) {
                RefdsText(.localizable(by: title), style: .callout, weight: .bold)
                RefdsText(.localizable(by: description), style: .callout, color: .secondary)
            }
            Spacer(minLength: .zero)
        }
    }
}

#Preview {
    List {
        EmptyRowView(title: .emptyTitle)
    }
}
