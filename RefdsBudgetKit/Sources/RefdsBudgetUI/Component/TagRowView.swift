import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct TagRowView: View {
    @Environment(\.privacyMode) private var privacyMode
    private let viewData: TagRowViewDataProtocol
    private let isSelected: Bool
    
    public init(viewData: TagRowViewDataProtocol, isSelected: Bool) {
        self.viewData = viewData
        self.isSelected = isSelected
    }
    
    public var body: some View {
        content
    }
    
    private var content: some View {
        HStack(spacing: .padding(.medium)) {
            RefdsIconRow(viewData.icon, color: viewData.color)
            
            VStack(alignment: .leading) {
                RefdsText(viewData.name.capitalized, style: .callout)
                
                if let amount = viewData.amount {
                    RefdsText(
                        .localizable(by: .homeRemainingCategoryTransactions, with: amount),
                        style: .callout,
                        color: .secondary
                    )
                    .refdsRedacted(if: privacyMode)
                }
            }
            
            Spacer(minLength: .zero)
            if let value = viewData.value {
                RefdsText(value.currency(), style: .callout)
                    .refdsRedacted(if: privacyMode)
            }
        }
    }
}

#Preview {
    List {
        TagRowView(viewData: TagRowViewDataMock(), isSelected: .random())
    }
}
