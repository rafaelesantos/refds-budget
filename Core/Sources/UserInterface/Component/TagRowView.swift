import SwiftUI
import RefdsUI
import RefdsShared
import Mock
import Domain
import Presentation

public struct TagItemView: View {
    @Environment(\.privacyMode) private var privacyMode
    private let viewData: TagItemViewDataProtocol
    private let isSelected: Bool
    
    public init(viewData: TagItemViewDataProtocol, isSelected: Bool) {
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
                RefdsText(value.currency(), style: .callout, weight: .semibold)
                    .refdsRedacted(if: privacyMode)
            }
            
            RefdsIcon(.chevronRight, color: .secondary.opacity(0.5), style: .callout)
        }
    }
}

#Preview {
    List {
        TagItemView(viewData: TagItemViewDataMock(), isSelected: .random())
    }
}
