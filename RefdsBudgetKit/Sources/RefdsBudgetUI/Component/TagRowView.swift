import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation

public struct TagRowView: View {
    private let viewData: TagRowViewDataProtocol
    private let action: ((TagRowViewDataProtocol) -> Void)?
    private let remove: ((TagRowViewDataProtocol) -> Void)?
    
    public init(
        viewData: TagRowViewDataProtocol,
        action: ((TagRowViewDataProtocol) -> Void)? = nil,
        remove: ((TagRowViewDataProtocol) -> Void)? = nil
    ) {
        self.viewData = viewData
        self.action = action
        self.remove = remove
    }
    
    public var body: some View {
        RefdsButton {
            action?(viewData)
        } label: {
            content
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            swipeRemoveButton
        }
        .contextMenu {
            contextRemoveButton
        }
    }
    
    private var content: some View {
        HStack(spacing: .padding(.medium)) {
            BubbleColorView(color: viewData.color, isSelected: false)
                .scaleEffect(0.6)
            RefdsText(viewData.name, style: .callout)
            Spacer(minLength: .zero)
            if let value = viewData.value {
                RefdsText(value.currency(), style: .callout, weight: .light)
            }
        }
    }
    
    private var swipeRemoveButton: some View {
        RefdsButton { 
            remove?(viewData)
        } label: {
            RefdsIcon(.trashFill)
        }
        .tint(.red)
    }
    
    private var contextRemoveButton: some View {
        RefdsButton {
            remove?(viewData)
        } label: {
            Label(
                String.localizable(by: .tagsRemoveTag),
                systemImage: RefdsIconSymbol.trashFill.rawValue
            )
        }
    }
}

#Preview {
    List {
        TagRowView(viewData: TagRowViewDataMock())
    }
}
