import SwiftUI
import RefdsUI
import RefdsBudgetResource

public struct AISuggestionLabel: View {
    private var isEnable: Bool
    
    public init(isEnable: Bool = true) {
        self.isEnable = isEnable
    }
    
    @ViewBuilder
    public var body: some View {
        if isEnable {
            HStack(spacing: 5) {
                RefdsIcon(
                    .boltFill,
                    color: .accentColor,
                    style: .footnote,
                    weight: .bold
                )
                
                RefdsText(
                    .localizable(by: .addBudgetAISuggestion).uppercased(),
                    style: .caption,
                    color: .accentColor,
                    weight: .bold
                )
            }
        }
    }
}

public struct AISuggestionButton: View {
    private var action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    @ViewBuilder
    public var body: some View {
        RefdsButton {
            withAnimation {
                action()
            }
        } label: {
            AISuggestionLabel()
        }
    }
}

#Preview {
    AISuggestionButton { }
}
